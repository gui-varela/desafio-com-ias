provider "aws" {
  region = "us-west-2"
}

# Referencia o bucket existente
data "aws_s3_bucket" "static_site" {
  bucket = "meu-site-estatico-bucket"
}

# Adiciona o arquivo index.html ao bucket existente
resource "aws_s3_bucket_object" "index" {
  bucket = data.aws_s3_bucket.static_site.bucket
  key    = "index.html"
  source = "site/index.html"
  acl    = "public-read"
}

# Adiciona o arquivo error.html ao bucket existente
resource "aws_s3_bucket_object" "error" {
  bucket = data.aws_s3_bucket.static_site.bucket
  key    = "error.html"
  source = "site/error.html"
  acl    = "public-read"
}

# Adiciona uma política de bucket para permitir acesso público
resource "aws_s3_bucket_policy" "static_site_policy" {
  bucket = data.aws_s3_bucket.static_site.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = "*"
        Action = "s3:GetObject"
        Resource = "${data.aws_s3_bucket.static_site.arn}/*"
      },
    ]
  })
}

# Exibe a URL do site
output "website_url" {
  value = data.aws_s3_bucket.static_site.website_endpoint
}
