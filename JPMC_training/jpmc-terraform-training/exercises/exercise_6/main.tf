
provider "aws" {
  region = "eu-west-1"
}

resource "aws_s3_bucket" "exp_bucket" {
  bucket = "cloud-image-bucket12"
}


resource "aws_s3_object" "image1" {
  bucket              = aws_s3_bucket.exp_bucket.bucket
  key                 = "image1"
  source              = "image1.png"
  content_type        = "image/png"
  content_disposition = "inline"
}

resource "aws_s3_object" "image2" {
  bucket              = aws_s3_bucket.exp_bucket.bucket
  key                 = "image2"
  source              = "image2.png"
  content_type        = "image/png"
  content_disposition = "inline"
}

resource "aws_cloudfront_origin_access_control" "Cf_xy" {
  name                              = "cf_xy"
  description                       = "Origin Access Control for S3 bucket"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
  origin_access_control_origin_type = "s3"
}

resource "aws_cloudfront_distribution" "deployment" {
  origin {
    domain_name              = aws_s3_bucket.exp_bucket.bucket_regional_domain_name
    origin_id                = "S3-Images-Origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.Cf_xy.id
  }

  enabled = true

  default_cache_behavior {
    target_origin_id       = "S3-Images-Origin"
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

  price_class = "PriceClass_200"

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.exp_bucket.bucket

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "s3:GetObject"
        Effect    = "Allow"
        Resource  = "arn:aws:s3:::${aws_s3_bucket.exp_bucket.bucket}/*" # Reference the actual S3 bucket
        Principal = "*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.deployment.arn
          }
        }
      }
    ]
  })
}

 