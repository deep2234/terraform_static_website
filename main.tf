resource "aws_s3_bucket" "my_bucket" {
  bucket = var.my_bucket_name
}

resource "aws_s3_bucket_ownership_controls" "s3_ownership" {
    bucket = aws_s3_bucket.my_bucket.id

    rule{
        object_ownership = "BucketOwnerPreferred"
    }

}