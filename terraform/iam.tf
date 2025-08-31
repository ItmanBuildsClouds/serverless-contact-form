resource "aws_iam_role" "iam_role_form" {
    name = "${var.project_name}-lambda-role"

    assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = { Service = "lambda.amazonaws.com"}
    }]
})

tags = {
    Project = var.project_name
    }
}

resource "aws_iam_policy" "iam_policy_form" {
    name = "${var.project_name}-lambda-policy"
    description = "IAM policy for the serverless contact form Lambda function."

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Action = [
                    "logs:CreateLogGroup",
                    "logs:CreateLogStream",
                    "logs:PutLogEvents"
                ],
                Resource = "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${var.project_name}-contact-form:*"
            },
            {
                Effect = "Allow",
                Action = "ses:SendEmail",
                Resource = "*"
            }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "iam_attachment_form" {
    role = aws_iam_role.iam_role_form.name
    policy_arn = aws_iam_policy.iam_policy_form.arn
}
