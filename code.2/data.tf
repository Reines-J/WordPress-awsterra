data "aws_subnet" "pub1"{
  vpc_id = aws_vpc.vpc.id
  filter {
    name = "subnet-id"
    values = [aws_subnet.pub[0].id]
  }
}

data "aws_subnet_ids" "pub"{
  vpc_id = aws_vpc.vpc.id
  filter {
    name = "subnet-id"
    values = aws_subnet.pub.*.id
  }
}

data "aws_subnet_ids" "pri"{
    vpc_id  = aws_vpc.vpc.id
    filter {
      name = "subnet-id"
      values = aws_subnet.pri.*.id
    }
}

data "aws_ami" "al2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

data "aws_iam_policy" "s3full"{
  name = "AmazonS3FullAccess"
}

data "aws_iam_policy_document" "assum-ec2"{
  statement {
    sid = ""
    principals {
      type = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_lb_target_group" "l7"{
  count = length(aws_lb_target_group.l7group.*.arn)
  arn = element(aws_lb_target_group.l7group.*.arn, count.index)
}
