provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "static_site" {
  bucket = "meu-site-estatico-bucket"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}


resource "aws_s3_bucket_object" "index" {
  bucket = aws_s3_bucket.static_site.bucket
  key    = "index.html"
  source = "site/index.html"
  acl    = "public-read"
}

resource "aws_s3_bucket_object" "error" {
  bucket = aws_s3_bucket.static_site.bucket
  key    = "error.html"
  source = "site/error.html"
  acl    = "public-read"
}

output "website_url" {
  value = aws_s3_bucket.static_site.website_endpoint
}

resource "aws_s3_bucket_policy" "static_site_policy" {
  bucket = aws_s3_bucket.static_site.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = "*"
        Action = "s3:GetObject"
        Resource = "${aws_s3_bucket.static_site.arn}/*"
      },
    ]
  })
}

