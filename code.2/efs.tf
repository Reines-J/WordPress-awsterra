resource "aws_efs_file_system" "efs" {
  creation_token = "efs-${var.name}"
  tags = { Name = "efs-${var.name}"  }
}

resource "aws_efs_mount_target" "efsmnt" {
  count = length(var.az)
  file_system_id = aws_efs_file_system.efs.id
  subnet_id = element(aws_subnet.pri.*.id, count.index)
  security_groups = [ "${aws_security_group.pri.id}" ]
}
