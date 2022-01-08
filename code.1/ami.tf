resource "aws_ami_from_instance" "terra-ami" {
  name = "terra-ami"
  source_instance_id = aws_instance.terra-wp.id
  tags = {Name = "terra-ami"}
}
