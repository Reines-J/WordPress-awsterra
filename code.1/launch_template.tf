resource "aws_launch_template" "terra-luanch" {
  name = "terra-launch"
  image_id = aws_ami_from_instance.terra-ami.id
  instance_initiated_shutdown_behavior = "terminate"
  instance_type = "t3.micro"
  key_name = aws_key_pair.terra-key.key_name
  tags = {Name = "terra-launch"}
  update_default_version = true
  network_interfaces {
      associate_public_ip_address = true
      delete_on_termination = true
      security_groups = [ "${aws_security_group.wp-sg.id}" ]
  }
  iam_instance_profile {
      name = aws_iam_instance_profile.ec2-s3.name
  }
  tag_specifications {
      resource_type = "instance"
      tags = {Name = "terra-wpauto"}
  }
  tag_specifications {
      resource_type = "volume"
      tags = {Name = "terra-volauto"}
  }
}
