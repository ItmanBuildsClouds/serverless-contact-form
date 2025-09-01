variable "aws_region" {
    type = string
    default = "eu-central-1"
}
variable "project_name" {
    type = string
    default = "serverless-contact-form"
}
variable "recipient_email" {
    type = string
    description = "Variable for the AWS SES service in AWS Lambda."
}
  