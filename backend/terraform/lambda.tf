data archive_file "lambda" {
  type        = "zip"
  source_dir  = "${path.module}/../lambda_src/"
  output_path = "${path.module}/../lambda_function.zip"
}

resource "aws_lambda_function" "contact_form_lambda" {
    filename = data.archive_file.lambda.output_path
    function_name = "${var.project_name}-function"
    role = aws_iam_role.iam_role.arn
    handler = "lambda_function.lambda_handler"
    source_code_hash = data.archive_file.lambda.output_base64sha256
    runtime = "python3.12"
    environment {
        variables = {
            RECIPIENT_MAIL = var.recipient_email
        }
    }

    tags = {
        Project = var.project_name
    }
}
resource "aws_lambda_permission" "api_gateway_permission" {
    statement_id = "AllowExecutionAPIGateway"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.contact_form_lambda.function_name
    principal = "apigateway.amazonaws.com"

    source_arn = "${aws_apigatewayv2_api.contact_api.execution_arn}/*/*"
}


