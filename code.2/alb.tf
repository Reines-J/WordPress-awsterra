resource "aws_lb" "l7" {
  name = "l7-${var.name}"
  internal = false
  load_balancer_type = "application"
  ip_address_type = "ipv4"
  security_groups = [aws_security_group.pub.id]
  subnets = data.aws_subnet_ids.pub.ids
  tags = { Name = "l7-${var.name}"}
}

resource "aws_lb_target_group" "l7group" {
  count = length(data.aws_subnet_ids.pub.ids)
  name = "l7group-${var.name}-${count.index}"
  port = 80
  protocol = "HTTP"
  target_type = "instance"
  vpc_id = aws_vpc.vpc.id
  health_check {
    protocol = "HTTP"
    path = "/"
  }
  tags = {NAME = "17group-${var.name}-${count.index}"}
}

resource "aws_lb_listener" "l7listen" {
  load_balancer_arn = aws_lb.l7.arn
  port = "80"
  protocol = "HTTP"
  default_action {
    type = "forward"
    forward{
      target_group{
        arn = data.aws_lb_target_group.l7[0].arn
      }
      target_group{
        arn = data.aws_lb_target_group.l7[1].arn
      }
    }
  }
  tags = {NAME = "l7listen-${var.name}"}
}

resource "aws_lb_target_group_attachment" "l7attach" {
  target_group_arn = aws_lb_target_group.l7group[0].arn
  target_id = aws_instance.wp.id
  port = 80
}
