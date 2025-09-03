terraform {
    backend "s3" {
    bucket = "contact-form-yjlbq"
    key = "serverless-contact-form/frontend.tfstate"
    region = "eu-central-1"
  }
}