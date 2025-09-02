output "api_endpoint_url" {
  value = "${aws_api_gateway_stage.contact-api-stage.invoke_url}/${aws_api_gateway_resource.contact-api-resource.path_part}"
}
