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

    restrict_public_buckets = false
    block_public_policy = false
}

data "aws_iam_policy_document" "s3_form_bucket_policy_document" {
  statement {
    actions = ["s3:GetObject"]
    principals {
      type = "AWS"
      identifiers = ["*"]
    }
    resources = ["${aws_s3_bucket.s3_form_bucket.arn}/*"]
  }
}


resource "aws_s3_bucket_policy" "s3_form_policy" {
  bucket = aws_s3_bucket.s3_form_bucket.id
  policy = data.aws_iam_policy_document.s3_form_bucket_policy_document.json
  
  depends_on = [ aws_s3_bucket_public_access_block.s3_form_public_access ]
}

resource "aws_s3_bucket_website_configuration" "example" {
  bucket = aws_s3_bucket.s3_form_bucket.id

  index_document {
    suffix = "index.html"
  }
}


