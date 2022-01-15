resource "aws_launch_template" "luanch" {
  name = "launch-${var.name}"
  image_id = aws_ami_from_instance.ami.id
  instance_initiated_shutdown_behavior = "terminate"
  instance_type = "t3.micro"
  key_name = aws_key_pair.key.key_name
  tags = {Name = "launch-${var.name}"}
  update_default_version = true
  network_interfaces {
      associate_public_ip_address = true
      delete_on_termination = true
      security_groups = [ "${aws_security_group.pub.id}" ]
  }
  iam_instance_profile {
      name = aws_iam_instance_profile.ec2-s3.name
  }
  tag_specifications {
      resource_type = "instance"
      tags = {Name = "wpauto-${var.name}"}
  }
  tag_specifications {
      resource_type = "volume"
      tags = {Name = "volauto-${var.name}"}
  }
}
