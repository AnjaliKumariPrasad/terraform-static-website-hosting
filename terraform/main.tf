terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}


data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "first_bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_public_access_block" "first_bucket_public_access_block" {
  bucket = aws_s3_bucket.first_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

locals {
  origin_id = "S3-${aws_s3_bucket.first_bucket.id}"
}

resource "aws_cloudfront_origin_access_control" "first_bucket_oac" {
  name                              = "first-bucket-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_s3_bucket_policy" "first_bucket_policy" {
  bucket = aws_s3_bucket.first_bucket.id

  depends_on = [
    aws_cloudfront_distribution.first_distribution
  ]

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Sid    = "AllowCloudFront"
        Effect = "Allow"

        Principal = {
          Service = "cloudfront.amazonaws.com"
        }

        Action = [
          "s3:GetObject"
        ]

        Resource = "${aws_s3_bucket.first_bucket.arn}/*"

        Condition = {
          StringEquals = {
            "AWS:SourceArn" = "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${aws_cloudfront_distribution.first_distribution.id}"
          }
        }
      }
    ]
  })
}

resource "aws_s3_object" "object1" {
  bucket = aws_s3_bucket.first_bucket.id

  for_each = fileset("${path.module}/WEB", "**/*")

  key    = each.value
  source = "${path.module}/WEB/${each.value}"

  etag = filemd5("${path.module}/WEB/${each.value}")

  content_type = lookup(
    {
      html = "text/html"
      css  = "text/css"
      js   = "application/javascript"
      png  = "image/png"
      jpg  = "image/jpeg"
      jpeg = "image/jpeg"
    },
    split(".", each.value)[length(split(".", each.value)) - 1],
    "application/octet-stream"
  )
}

resource "aws_cloudfront_distribution" "first_distribution" {

  origin {
    domain_name              = aws_s3_bucket.first_bucket.bucket_regional_domain_name
    origin_id                = local.origin_id
    origin_access_control_id = aws_cloudfront_origin_access_control.first_bucket_oac.id
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "First CloudFront Distribution"
  default_root_object = "index.html"

  default_cache_behavior {

    target_origin_id = local.origin_id

    allowed_methods = [
      "GET",
      "HEAD"
    ]

    cached_methods = [
      "GET",
      "HEAD"
    ]

    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

output "cloudfront_url" {
  value = aws_cloudfront_distribution.first_distribution.domain_name
}