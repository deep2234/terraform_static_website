resource "aws_s3_bucket" "my_bucket" {
  bucket = var.my_bucket_name
}

resource "aws_s3_bucket_ownership_controls" "s3_ownership" {
  bucket = aws_s3_bucket.my_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.my_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "dip_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.s3_ownership,
    aws_s3_bucket_public_access_block.example

  ]

  bucket = aws_s3_bucket.my_bucket.id
  acl    = "public-read"
}

resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.my_bucket.id
  key          = "index.html"
  source       = "index.html"
  acl          = "public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "error" {
  bucket       = aws_s3_bucket.my_bucket.id
  key          = "error.html"
  source       = "error.html"
  acl          = "public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "image" {
  bucket = aws_s3_bucket.my_bucket.id
  key    = "rock.png"
  source = "rock.png"
  acl    = "public-read"
}

resource "aws_s3_bucket_website_configuration" "dipwebsite"{

  bucket = aws_s3_bucket.my_bucket.id

  index_document{
    suffix = "index.html"

  }

  error_document{
    key = "error.html"
  }

  depends_on = [aws_s3_bucket_acl.dip_acl]

}