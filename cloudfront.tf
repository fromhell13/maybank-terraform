# CloudFront Distribution
resource "aws_cloudfront_distribution" "cdn" {
  origin {
     domain_name              = aws_s3_bucket.my_s3_bucket.bucket_regional_domain_name
    origin_access_control_id  = aws_cloudfront_origin_access_control.oac.id
    origin_id                 = "${aws_s3_bucket.my_s3_bucket.id}.s3.${var.aws_region}.amazonaws.com"
  }

  origin {
    domain_name = aws_lb.public_nlb.dns_name
    origin_id   = "NLBOrigin"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2", "TLSv1.1", "TLSv1"]
    }
  }

  default_cache_behavior {
    target_origin_id       = "${aws_s3_bucket.my_s3_bucket.id}.s3.${var.aws_region}.amazonaws.com"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  ordered_cache_behavior {
    path_pattern           = "/api/*"
    target_origin_id       = "NLBOrigin"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods  = ["GET", "HEAD"]

    forwarded_values {
      query_string = true
      cookies {
        forward = "all"
      }
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  price_class = "PriceClass_100"
  enabled     = true
}


resource "aws_cloudfront_origin_access_control" "oac" {
  name  = "${aws_s3_bucket.my_s3_bucket.id}.s3.${var.aws_region}.amazonaws.com"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}
