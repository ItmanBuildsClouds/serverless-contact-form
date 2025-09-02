terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
     random = {
      source = "hashicorp/random"
      version = "3.7.2"
    }
  }
}
provider "aws" {
  region = var.aws_region
}

resource "random_string" "suffix" {
    length = 5
    special = false
    upper = false
}

resource "aws_s3_bucket" "remote_s3_bucket" {
  bucket = "${var.bucket_prefix}-${random_string.suffix.result}"
  tags = {
    Project = var.project_name
  }
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_public_access_block" "remote_s3_pab" {
  bucket = aws_s3_bucket.remote_s3_bucket.id
  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "remote_s3_versioning" {
    bucket = aws_s3_bucket.remote_s3_bucket.id
    versioning_configuration {
      status = "Enabled"
    }
}
output "s3_form_bucket" {
    description = "The name for S3 bucket for storing Terraform state."
    value = aws_s3_bucket.remote_s3_bucket.id
}
output "s3_website_url" {
    value = aws_s3_bucket.remote_s3_bucket.website_endpoint
}

