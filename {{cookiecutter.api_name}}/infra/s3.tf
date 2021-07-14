resource "aws_s3_bucket" "_" {
  bucket = "{{cookiecutter.domain_name}}-{{cookiecutter.api_name}}"
  acl    = "private"

  tags = {
    Project = "{{cookiecutter.domain_name}}"
  }
}

resource "aws_s3_bucket_public_access_block" "bucket_block_public_access" {
  bucket = aws_s3_bucket._.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}