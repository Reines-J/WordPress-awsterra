resource "aws_cloudfront_origin_access_identity" "terra-front" {
  comment = "terra-front"
}

resource "aws_cloudfront_distribution" "terra-frontl7" {
  enabled = true
  comment = "trra-fornt"
  price_class = "PriceClass_All"
  restrictions {
    geo_restriction{
      restriction_type = "none"
    }
  }
  viewer_certificate {
    cloudfront_default_certificate = true
  }
  origin {
    domain_name = aws_lb.terra-l7.dns_name
    origin_id = "terra-frontl7"
    connection_attempts = 1
    connection_timeout = 1
    custom_origin_config {
      origin_keepalive_timeout = 1
      origin_read_timeout = 1
      http_port = 80
      https_port = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols = ["TLSv1"]
    }
  }
  default_cache_behavior {
    viewer_protocol_policy = "allow-all"
    allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods = [ "GET", "HEAD" ]
    target_origin_id = "terra-frontl7"
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }
  origin {
    domain_name = aws_s3_bucket.terra-s3.bucket_domain_name
    origin_id = "terra-fronts3"
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.terra-front.cloudfront_access_identity_path
    }
  }
}
