resource "aws_apigatewayv2_api" "contact_api" {
  name = "api_backend"
  protocol_type = "HTTP"
  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["POST", "OPTIONS"]
    allow_headers = ["Content-Type"]
  }
}
resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id           = aws_apigatewayv2_api.contact_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.contact_form_lambda.invoke_arn
}

resource "aws_apigatewayv2_route" "contact_route" {
  api_id             = aws_apigatewayv2_api.contact_api.id
  route_key          = "POST /contact"
  target             = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}
resource "aws_apigatewayv2_stage" "api_stage" {
  api_id      = aws_apigatewayv2_api.contact_api.id
  name        = "$default"
  auto_deploy = true
}
resource "aws_apigatewayv2_domain_name" "api_domain" {
  domain_name = "api.${var.domain_name}"
  domain_name_configuration {
    certificate_arn = data.terraform_remote_state.certificate_regional.outputs.regional_certificate_arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}
resource "aws_apigatewayv2_api_mapping" "api_mapping" {
  api_id      = aws_apigatewayv2_api.contact_api.id
  domain_name = aws_apigatewayv2_domain_name.api_domain.id
  stage       = aws_apigatewayv2_stage.api_stage.id
}