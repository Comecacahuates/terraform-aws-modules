# ==============================================================================
# Lambda Function + IAM
# ==============================================================================

resource "aws_iam_role" "lambda" {
  name = "${var.name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })

  tags = var.tags
}

resource "aws_iam_role_policy" "lambda" {
  name = "${var.name}-policy"
  role = aws_iam_role.lambda.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = concat(
      [
        {
          Effect   = "Allow"
          Action   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
          Resource = "arn:aws:logs:*:*:*"
        }
      ],
      [for s in var.policy_statements : {
        Effect   = "Allow"
        Action   = s.Action
        Resource = s.Resource
      }]
    )
  })
}

resource "aws_lambda_function" "this" {
  function_name    = var.name
  role             = aws_iam_role.lambda.arn
  handler          = "bootstrap"
  runtime          = "provided.al2023"
  architectures    = ["x86_64"]
  memory_size      = var.memory_size
  timeout          = var.timeout
  filename         = var.source_file
  source_code_hash = filebase64sha256(var.source_file)

  environment {
    variables = var.environment_variables
  }

  tags = var.tags
}
