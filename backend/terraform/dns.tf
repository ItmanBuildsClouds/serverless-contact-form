resource "aws_route53_record" "zone_dns" {
    zone_id = data.aws_route53_zone.domain_zone.zone_id
    name = "api"
    type = "A"

    alias {
    name = aws_apigatewayv2_domain_name.api_domain.domain_name_configuration[0].target_domain_name
    zone_id = aws_apigatewayv2_domain_name.api_domain.domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = false
    }
}