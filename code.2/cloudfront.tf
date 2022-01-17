resource "aws_cloudfront_origin_access_identity" "front" {
  comment = "front-${var.name}"
}

resource "aws_cloudfront_distribution" "frontl7" {
  enabled = true
  comment = "fornt-${var.name}"
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
    domain_name = aws_lb.l7.dns_name
    origin_id = "frontl7-${var.name}"
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
    allowed_methods = "${var.cl-allow}"
    cached_methods = "${var.cl-cached}"
    target_origin_id = "frontl7-${var.name}"
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }
  origin {
    domain_name = aws_s3_bucket.s3.bucket_domain_name
    origin_id = "fronts3-${var.name}"
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.front.cloudfront_access_identity_path
    }
  }
}
