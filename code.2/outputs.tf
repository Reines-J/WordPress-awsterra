output "region"{
  description = "Region aws"
  value = var.region
}

output "AZ"{
  description = "Availability zone list of VPC"
  value = var.az
}

output "vpc-id"{
  description = "vpc-id"
  value = aws_vpc.vpc.id
}

output "cidr_block"{
  description = "cidr_block of vpc"
  value = aws_vpc.vpc.cidr_block
}

output "public_subnets" {
  description = "pub-subid"
  value       = aws_subnet.pub.*.id
}

output "private_subnets" {
  description = "pri-subid"
  value       = aws_subnet.pri.*.id
}

output "public_SGid"{
  description = "public Security Group "
  value = aws_security_group.pub.id
}

output "private_SGid"{
  description = "private Security Group "
  value = aws_security_group.pri.id
}

output "ec2-id"{
  description = "ec2-id"
  value = aws_instance.wp.id
}

output "s3-bucket"{
  description = "s3 bucket name"
  value = aws_s3_bucket.s3.bucket_domain_name
}

output "efs-id"{
  description = "Elastic File System id"
  value = aws_efs_file_system.efs.id
}

output "rds-end"{
  description = "Rds Endpoint"
  value = aws_db_instance.rds.address
}

output "rolepolicy"{
  description = "ec2 rolepolicy"
  value = aws_iam_role_policy.rolepol.policy
}

output "ELB"{
  description = "ELB-l7"
  value = aws_lb.l7.arn
}

output "targetgroup"{
  description = "target-group"
  value = aws_lb_target_group.l7group.*.id
}

output "cl"{
  description = "cloudfront-l7"
  value = aws_cloudfront_origin_access_identity.front.id
}

output "cl-origin"{
  description = "cloudfront-origin"
  value = aws_cloudfront_distribution.frontl7.domain_name
}