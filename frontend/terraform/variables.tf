variable "aws_region" {
    type = string
    default = "eu-central-1"
}
variable "project_name" {
    type = string
    default = "serverless-contact-form"
}
variable "bucket_prefix" {
    description = "Name of S3 bucket for Form website."
    type = string
    default = "contact-form"
}