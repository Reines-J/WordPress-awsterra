resource "aws_s3_bucket" "s3" {
  bucket = "s3-${var.name}.2"
  
}

resource "aws_s3_bucket_public_access_block" "s3-pub" {
  bucket = aws_s3_bucket.s3.id
  block_public_acls = false
  block_public_policy = false
  ignore_public_acls = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "s3-pol" {
  bucket = aws_s3_bucket.s3.id

  policy = jsonencode({
    Version: "2012-10-17",
    Statement: [
      {
        Sid: "PublicReadGetObject",
        Effect: "Allow",
        Principal: "*",
        Action: [
          "s3:GetObject"
        ],
      Resource: [
        "${aws_s3_bucket.s3.arn}/*"
        ]
    }
  ]
    })
}

