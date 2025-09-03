terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
    backend "s3" {
    bucket = "contact-form-yjlbq"
    key    = "serverless-contact-form/certificate-regional.tfstate"
    region = "eu-central-1"
  }
}
##for certificate
provider "aws" {
  region = "eu-central-1"
}

data "aws_route53_zone" "domain_main_regional" {
    name = var.domain
}

resource "aws_acm_certificate" "certificate_regional" {
    domain_name = var.domain
    subject_alternative_names = ["*.${var.domain}"]
    validation_method = "DNS"

    lifecycle {
      create_before_destroy = true
    }
}

resource "aws_route53_record" "route_53_record_regional" {
    for_each = {
        for dvo in aws_acm_certificate.certificate_regional.domain_validation_options : dvo.domain_name => {
            name = dvo.resource_record_name
            record = dvo.resource_record_value
            type = dvo.resource_record_type
        }
    }
    allow_overwrite = true
    zone_id = data.aws_route53_zone.domain_main_regional.zone_id
    name = each.value.name
    type = each.value.type
    records = [each.value.record]
    ttl = 60
}

resource "aws_acm_certificate_validation" "validation_regional" {
    certificate_arn = aws_acm_certificate.certificate_regional.arn
    validation_record_fqdns = [for record in aws_route53_record.route_53_record_regional : record.fqdn]
}

output "regional_certificate_arn" {
    description = "ARN of validated ACM cert."
    value = aws_acm_certificate_validation.validation_regional.certificate_arn
}