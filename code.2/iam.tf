resource "aws_iam_role" "role" {
  name               = "role-${var.name}"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assum-ec2.json
}

resource "aws_iam_role_policy" "rolepol" {
  name   = "pol-${var.name}"
  role   = aws_iam_role.role.id
  policy = data.aws_iam_policy.s3full.policy
}

resource "aws_iam_instance_profile" "ec2-s3" {
  name = "ec2-s3"
  role = aws_iam_role.role.name
}
