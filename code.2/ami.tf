resource "aws_ami_from_instance" "ami" {
  name = "ami-${var.name}"
  source_instance_id = aws_instance.wp.id
  tags = {Name = "ami-${var.name}"}
}
