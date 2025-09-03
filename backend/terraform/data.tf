data "aws_route53_zone" "domain_zone" {
    name = var.domain_name
}

data "terraform_remote_state" "certificate_regional" {
    backend = "s3"

    config = {
        bucket = "contact-form-yjlbq"
        key = "serverless-contact-form/certificate-regional.tfstate"
        region = "eu-central-1"
    }
}