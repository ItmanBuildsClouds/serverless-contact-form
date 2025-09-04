data "terraform_remote_state" "certificate_global" {
    backend = "s3"
    config = {
        bucket = "contact-form-yjlbq"
        key = "serverless-contact-form/certificate.tfstate"
        region = "eu-central-1"
    }
}
data "aws_route53_zone" "zone_domain" {
    name = var.domain_name
}
