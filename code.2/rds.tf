resource "aws_db_instance" "rds" {
  engine = "MySQL"
  engine_version = "8.0.23"
  multi_az = true
  username = "root"
  password = "qwe12345"
  instance_class = "db.t3.micro"
  name = "rds${var.name}"
  identifier = "rds-${var.name}"
  allocated_storage = 10
  storage_type = "gp2"
  backup_retention_period = 1
  copy_tags_to_snapshot = true
  skip_final_snapshot = true
  db_subnet_group_name = aws_db_subnet_group.rdssubnet.name
  parameter_group_name = aws_db_parameter_group.rdspara.name
  vpc_security_group_ids = [ "${aws_security_group.pri.id}" ]
  tags = {Name = "rds-${var.name}"}
}
