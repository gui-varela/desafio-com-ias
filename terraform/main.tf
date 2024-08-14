provider "aws" {
  region = "eu-west-1"  # Certifique-se de que esta seja a região correta
}

# Cria o bucket S3 com um nome único
resource "aws_s3_bucket" "static_site" {
  bucket = "elogroup-f783b9a"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
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
