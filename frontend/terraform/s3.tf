resource "random_string" "bucket_suffix" {
    length = 5
    upper = false
    special = false
}

resource "aws_s3_bucket" "s3_form_bucket" {
  bucket = "${var.bucket_prefix}-${random_string.bucket_suffix.result}"

  tags = {
    Name = var.bucket_prefix
    Project = var.project_name
  }
}
resource "aws_s3_bucket_public_access_block" "s3_form_public_access" {
    bucket = aws_s3_bucket.s3_form_bucket.id

    block_public_acls = true
    ignore_public_acls = true

    restrict_public_buckets = true
    block_public_policy = true
}

