resource "aws_cloudfront_origin_access_identity" "cf_access" {
  comment = "Origin Access Identity"
}

resource "aws_cloudfront_distribution" "cf_dist" {

aliases = [var.domain_name, "www.${var.domain_name}"]

  origin {
    domain_name = aws_s3_bucket.s3_form_bucket.bucket_regional_domain_name
    origin_id   = "S3-${var.bucket_prefix}"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.cf_access.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront distribution for ${var.project_name}"
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods = [
      "GET",
      "HEAD",
      "OPTIONS",
      ]
    cached_methods = [
      "GET",
      "HEAD",
    ]

    target_origin_id = "S3-${var.bucket_prefix}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Project = var.project_name
  }

  viewer_certificate {
    acm_certificate_arn = data.terraform_remote_state.certificate_global.outputs.certificate_arn
    ssl_support_method  = "sni-only"
  }
}