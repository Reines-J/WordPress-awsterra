resource "aws_key_pair" "key" {
    key_name = "key-${var.name}"
    public_key = file("/mnt/c/Users/khung/Desktop/terraform/terra-key.pub")
    tags = { Name = "key-${var.name}"}
}

resource "aws_instance" "wp" {
  ami = data.aws_ami.al2.id
  instance_type = "t3.micro"
  subnet_id = data.aws_subnet.pub1.id
  iam_instance_profile = aws_iam_instance_profile.ec2-s3.name
  key_name = aws_key_pair.key.key_name
  instance_initiated_shutdown_behavior = "terminate"
  vpc_security_group_ids = [aws_security_group.pub.id]
  user_data = templatefile("wpuserdata.tpl", 
  {efs = aws_efs_file_system.efs.id, rdsname = aws_db_instance.rds.name, rdsend = aws_db_instance.rds.endpoint})
  tags = {Name = "wp-${var.name}"} 
}

resource "aws_eip_association" "eip" {
  instance_id = aws_instance.wp.id
  allocation_id = aws_eip.eip.id
}

