resource "aws_autoscaling_group" "terra-autogroup" {
  name = "terra-autogroup"
  desired_capacity = 2
  min_size = 2
  max_size = 4
  health_check_grace_period = 60
  health_check_type = "ELB"
  force_delete = true
  vpc_zone_identifier = [ "${aws_subnet.wp_pub1.id}", "${aws_subnet.wp_pub2.id}" ]
  target_group_arns = [ "${aws_lb_target_group.terra-l7group.arn}" ]
  launch_template {
    id = aws_launch_template.terra-luanch.id
    version = "$Latest"
  }
  tags = [ {
    "Name" = "terra-autogroup"
  } ]
}

resource "aws_autoscaling_policy" "terra-autopolicy" {
  name = "terra-autopolicy"
  adjustment_type = "PercentChangeInCapacity"
  policy_type = "TargetTrackingScaling"
  estimated_instance_warmup = 60
  autoscaling_group_name = aws_autoscaling_group.terra-autogroup.name
  target_tracking_configuration {
      predefined_metric_specification {
        predefined_metric_type = "ASGAverageCPUUtilization"
      }
      target_value = 30
  }
}

resource "aws_autoscaling_attachment" "terra-autoattach" {
  autoscaling_group_name = aws_autoscaling_group.terra-autogroup.name
}