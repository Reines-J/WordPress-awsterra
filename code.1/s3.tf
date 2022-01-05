resource "aws_s3_bucket" "terra-s3" {
  bucket = "terra-s3-wp"
  
}

resource "aws_s3_bucket_public_access_block" "terra-s3-pub" {
  bucket = aws_s3_bucket.terra-s3.id
  block_public_acls = false
  block_public_policy = false
  ignore_public_acls = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "terra-s3-pol" {
  bucket = aws_s3_bucket.terra-s3.id

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
        "${aws_s3_bucket.terra-s3.arn}/*"
        ]
    }
  ]
    })
}

