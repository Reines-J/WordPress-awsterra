resource "aws_vpc" "vpc" {
  cidr_block       = "10.${var.cidr}.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "${var.vpc_name}"
  }
}

resource "aws_subnet" "pub" {
  count = length(var.az)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.${var.cidr}.${var.cidr_public[count.index]}.0/24"
  availability_zone = element(var.az, count.index)

  tags = {
    Name = "subpub${count.index}-${var.vpc_name}"
  }
}

resource "aws_subnet" "pri" {
  count = length(var.az)
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.${var.cidr}.${var.cidr_private[count.index]}.0/24"
  availability_zone = element(var.az, count.index)

  tags = {
    Name = "subpri${count.index}-${var.vpc_name}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "igw-${var.vpc_name}"
  }
}

resource "aws_route_table" "pub" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "rtpub-${var.vpc_name}"
  }
}

resource "aws_route_table" "pri" {
  vpc_id = aws_vpc.vpc.id                                                                                                                       
  tags = {
    Name = "rtpri-${var.vpc_name}"
  }
}

resource "aws_route_table_association" "pub" {
  count = length(aws_subnet.pub.*.id)
  subnet_id = element(aws_subnet.pub.*.id, count.index)
  route_table_id = aws_route_table.pub.id
}

resource "aws_route_table_association" "pri" {
  count = length(aws_subnet.pri.*.id)
  subnet_id = element(aws_subnet.pri.*.id, count.index)
  route_table_id = aws_route_table.pri.id
}

resource "aws_route" "pub" {
  route_table_id = aws_route_table.pub.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}

resource "aws_security_group" "pub" {
  vpc_id = aws_vpc.vpc.id
  name = "sgpub-${var.vpc_name}"
  description = "suve-sg"
  tags = { Name = "sgpub-${var.vpc_name}"}
}

resource "aws_security_group" "pri" {
  vpc_id = aws_vpc.vpc.id
  name = "sgpri-${var.vpc_name}"
  description = "volume-sg"
  tags = { Name = "sgpri-${var.vpc_name}"}
}

resource "aws_security_group_rule" "ssh" {
  type = "ingress"
  from_port =  22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = [ "0.0.0.0/0" ]
  security_group_id = aws_security_group.pub.id
}

resource "aws_security_group_rule" "http" {
  type = "ingress"
  from_port =  80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = [ "0.0.0.0/0" ]
  security_group_id = aws_security_group.pub.id
}

resource "aws_security_group_rule" "nfs" {
  type = "ingress"
  from_port = 2049
  to_port = 2049
  protocol = "tcp"
  source_security_group_id = aws_security_group.pub.id
  security_group_id = aws_security_group.pri.id
}

resource "aws_security_group_rule" "mysql" {
  type = "ingress"
  from_port = 3306
  to_port = 3306
  protocol = "tcp"
  source_security_group_id = aws_security_group.pub.id
  security_group_id = aws_security_group.pri.id
}

resource "aws_security_group_rule" "wp-outboundall" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = [ "0.0.0.0/0"]
  security_group_id = aws_security_group.pub.id
}

resource "aws_security_group_rule" "vol-outboundall" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = [ "0.0.0.0/0"]
  security_group_id = aws_security_group.pri.id
}
