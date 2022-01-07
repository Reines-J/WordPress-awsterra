resource "aws_efs_file_system" "terra-efs" {
  creation_token = "terra-efs"
  tags = { Name = "terra-efs"  }
}

resource "aws_efs_mount_target" "terra-efsmnt1" {
  file_system_id = aws_efs_file_system.terra-efs.id
  subnet_id = aws_subnet.volume_pri2.id
  security_groups = [ "${aws_security_group.vol-sg.id}" ]
}

resource "aws_efs_mount_target" "terra-efsmnt2" {
  file_system_id = aws_efs_file_system.terra-efs.id
  subnet_id = aws_subnet.volume_pri1.id
  security_groups = [ "${aws_security_group.vol-sg.id}" ]
}