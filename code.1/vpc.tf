resource "aws_vpc" "wp_vpc" {
  cidr_block       = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "terra-wpvpc"
  }
}

resource "aws_subnet" "wp_pub1" {
  vpc_id     = aws_vpc.wp_vpc.id
  cidr_block = "10.0.1.0/24"

  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "terra-pub1"
  }
}

resource "aws_subnet" "wp_pub2" {
  vpc_id     = aws_vpc.wp_vpc.id
  cidr_block = "10.0.2.0/24"

  availability_zone = "ap-northeast-2b"

  tags = {
    Name = "terra-pub2"
  }
}

resource "aws_subnet" "volume_pri1" {
  vpc_id = aws_vpc.wp_vpc.id
  cidr_block = "10.0.3.0/24"

  availability_zone = "ap-northeast-2a"
  
  tags = {
    Name = "terra-pri1"
  }
}

resource "aws_subnet" "volume_pri2" {
  vpc_id = aws_vpc.wp_vpc.id
  cidr_block = "10.0.4.0/24"

  availability_zone = "ap-northeast-2b"
  
  tags = {
    Name = "terra-pri2"
  }
}

resource "aws_internet_gateway" "wp_igw" {
  vpc_id = aws_vpc.wp_vpc.id

  tags = {
    Name = "terra-igw"
  }
}

resource "aws_route_table" "wp_pub" {
  vpc_id = aws_vpc.wp_vpc.id

  tags = {
    Name = "terra-pub"
  }
}
resource "aws_route" "pub_igw" {
  route_table_id = aws_route_table.wp_pub.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.wp_igw.id
}

resource "aws_route_table" "volume_pri" {
  vpc_id = aws_vpc.wp_vpc.id                                                                                                                       
  tags = {
    Name = "terra-pri"
  }
}

resource "aws_route_table_association" "wp_pub1_assoc" {
  subnet_id = aws_subnet.wp_pub1.id
  route_table_id = aws_route_table.wp_pub.id
}

resource "aws_route_table_association" "wp_pub2_assoc" {
  subnet_id = aws_subnet.wp_pub2.id
  route_table_id = aws_route_table.wp_pub.id
}

resource "aws_route_table_association" "volume_pri1_assoc" {
  subnet_id = aws_subnet.volume_pri1.id
  route_table_id = aws_route_table.volume_pri.id
}

resource "aws_route_table_association" "volume_pri2_assoc" {
  subnet_id = aws_subnet.volume_pri2.id
  route_table_id = aws_route_table.volume_pri.id
}


resource "aws_security_group" "wp-sg" {
  vpc_id = aws_vpc.wp_vpc.id
  name = "wp-sg"
  description = "public"
  tags = { Name = "wp-sg"}
}

resource "aws_security_group" "vol-sg" {
  vpc_id = aws_vpc.wp_vpc.id
  name = "vol-sg"
  description = "private"
  tags = { Name = "vol-sg"}
}

resource "aws_security_group_rule" "ssh" {
  type = "ingress"
  from_port =  22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = [ "0.0.0.0/0" ]
  security_group_id = aws_security_group.wp-sg.id
}

resource "aws_security_group_rule" "http" {
  type = "ingress"
  from_port =  80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = [ "0.0.0.0/0" ]
  security_group_id = aws_security_group.wp-sg.id
}

resource "aws_security_group_rule" "nfs" {
  type = "ingress"
  from_port = 2049
  to_port = 2049
  protocol = "tcp"
  source_security_group_id = aws_security_group.wp-sg.id
  security_group_id = aws_security_group.vol-sg.id
}

resource "aws_security_group_rule" "mysql" {
  type = "ingress"
  from_port = 3306
  to_port = 3306
  protocol = "tcp"
  source_security_group_id = aws_security_group.wp-sg.id
  security_group_id = aws_security_group.vol-sg.id
}

resource "aws_security_group_rule" "wp-outboundall" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = [ "0.0.0.0/0"]
  security_group_id = aws_security_group.wp-sg.id
}

resource "aws_security_group_rule" "vol-outboundall" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = [ "0.0.0.0/0"]
  security_group_id = aws_security_group.vol-sg.id
}
