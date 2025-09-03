output "api_endpoint_url" {
  value = "${aws_apigatewayv2_api.contact_api.api_endpoint}/contact"
}
