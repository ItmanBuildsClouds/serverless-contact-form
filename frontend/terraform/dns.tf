resource "aws_route53_record" "dns_url" {
    zone_id = data.aws_route53_zone.zone_domain.zone_id
    name = var.domain_name
    type = "A"
    
    alias {
    name = aws_cloudfront_distribution.cf_dist.domain_name
    zone_id = aws_cloudfront_distribution.cf_dist.hosted_zone_id
    evaluate_target_health = false
    }
}
resource "aws_route53_record" "www_dns_record" {
  zone_id = data.aws_route53_zone.zone_domain.id
  name = "www"
  type = "A"

  alias {
    name = aws_cloudfront_distribution.cf_dist.domain_name
    zone_id = aws_cloudfront_distribution.cf_dist.hosted_zone_id
    evaluate_target_health = false
  }
}