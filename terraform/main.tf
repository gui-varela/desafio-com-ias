provider "aws" {
  region = "us-east-1"  # Substitua pela região desejada
}

# Cria o bucket S3
resource "aws_s3_bucket" "static_site" {
  bucket = "meu-site-estatico-bucket"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  # O ACL pode ser removido se for usado ObjectOwnership BucketOwnerEnforced
  acl    = "public-read"
}

# Adiciona o arquivo index.html ao bucket
resource "aws_s3_bucket_object" "index" {
  bucket = aws_s3_bucket.static_site.bucket
  key    = "index.html"
  source = "site/index.html"
  acl    = "public-read"
}

# Adiciona o arquivo error.html ao bucket
resource "aws_s3_bucket_object" "error" {
  bucket = aws_s3_bucket.static_site.bucket
  key    = "error.html"
  source = "site/error.html"
  acl    = "public-read"
}

# Adiciona uma política de bucket para permitir acesso público
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

# Exibe a URL do site
output "website_url" {
  value = aws_s3_bucket.static_site.website_endpoint
}
