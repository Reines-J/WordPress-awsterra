resource "aws_autoscaling_group" "autogroup" {
  name = "autogroup-${var.name}"
  desired_capacity = 2
  min_size = 2
  max_size = 4
  health_check_grace_period = 60
  health_check_type = "ELB"
  force_delete = true
  vpc_zone_identifier = data.aws_subnet_ids.pub.ids
  target_group_arns = aws_lb_target_group.l7group.*.arn
  launch_template {
    id = aws_launch_template.luanch.id
    version = "$Latest"
  }
  tags = [ {
    "Name" = "autogroup-${var.name}"
  } ]
}

resource "aws_autoscaling_policy" "autopolicy" {
  name = "autopolicy-${var.name}"
  adjustment_type = "PercentChangeInCapacity"
  policy_type = "TargetTrackingScaling"
  estimated_instance_warmup = 60
  autoscaling_group_name = aws_autoscaling_group.autogroup.name
  target_tracking_configuration {
      predefined_metric_specification {
        predefined_metric_type = "ASGAverageCPUUtilization"
      }
      target_value = 30
  }
}

resource "aws_autoscaling_attachment" "autoattach" {
  autoscaling_group_name = aws_autoscaling_group.autogroup.name
}
