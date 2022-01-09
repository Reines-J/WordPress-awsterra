resource "aws_lb" "terra-l7" {
  name = "terra-l7"
  internal = false
  load_balancer_type = "application"
  ip_address_type = "ipv4"
  security_groups = [aws_security_group.wp-sg.id]
  subnets = [aws_subnet.wp_pub1.id, aws_subnet.wp_pub2.id]
  tags = { Name = "terral7"}
}

resource "aws_lb_target_group" "terra-l7group" {
  name = "terra-l7group"
  port = 80
  protocol = "HTTP"
  target_type = "instance"
  vpc_id = aws_vpc.wp_vpc.id
  health_check {
    protocol = "HTTP"
    path = "/"
  }
  tags = {NAME = "terra-l7group"}
}

resource "aws_lb_listener" "terra-l7listen" {
  load_balancer_arn = aws_lb.terra-l7.arn
  port = "80"
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.terra-l7group.id
  }
  tags = {NAME = "terra-l7listen"}
}

resource "aws_lb_target_group_attachment" "terra-l7attach" {
  target_group_arn = aws_lb_target_group.terra-l7group.arn
  target_id = aws_instance.terra-wp.id
  port = 80
}
