resource "aws_api_gateway_rest_api" "contact-api" {
  name = "${var.project_name}-api-gateway"
  description = "API Gateway for ${var.project_name}"
}
resource "aws_api_gateway_resource" "contact-api-resource" {
  rest_api_id = aws_api_gateway_rest_api.contact-api.id
  parent_id = aws_api_gateway_rest_api.contact-api.root_resource_id
  path_part = "contact"
}
resource "aws_api_gateway_method" "contact-api-method" {
  rest_api_id = aws_api_gateway_rest_api.contact-api.id
  resource_id = aws_api_gateway_resource.contact-api-resource.id
  http_method = "POST"
  authorization = "NONE"
}
resource "aws_api_gateway_integration" "contact-api-integration" {
  rest_api_id = aws_api_gateway_rest_api.contact-api.id
  resource_id = aws_api_gateway_resource.contact-api-resource.id
  http_method = aws_api_gateway_method.contact-api-method.http_method
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = aws_lambda_function.contact_form_lambda.invoke_arn
}

resource "aws_api_gateway_deployment" "contact-api-deployment" {
    rest_api_id = aws_api_gateway_rest_api.contact-api.id
    triggers = {
        redeployment = sha1(jsonencode([
            aws_api_gateway_resource.contact-api-resource.id,
            aws_api_gateway_method.contact-api-method.id,
            aws_api_gateway_integration.contact-api-integration.id
        ]))
    }
    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_api_gateway_stage" "contact-api-stage" {
    deployment_id = aws_api_gateway_deployment.contact-api-deployment.id
    rest_api_id = aws_api_gateway_rest_api.contact-api.id
    stage_name = "prod"
}