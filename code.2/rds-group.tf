resource "aws_db_subnet_group" "rdssubnet" {
  name = "rdssubnet-${var.name}"
  subnet_ids = data.aws_subnet_ids.pri.ids
  tags = {Name = "rdssubnet-${var.name}"}
}

resource "aws_db_parameter_group" "rdspara" {
  name = "rdspara-${var.name}"
  family = "mysql8.0"
  tags = {Name = "rdspara-${var.name}"}
}
