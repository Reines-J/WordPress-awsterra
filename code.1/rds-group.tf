resource "aws_db_subnet_group" "terra-rdssubnet" {
  name = "terra-rdssubnet"
  subnet_ids = [aws_subnet.volume_pri1.id, aws_subnet.volume_pri2.id]
  tags = {Name = "terra-rdssubnet"}
}

resource "aws_db_parameter_group" "terra-rdspara" {
  name = "terra-rdspara"
  family = "mysql8.0"
  tags = {Name = "terra-rdspara"}
}
