resource "aws_api_gateway_resource" "this" {
  rest_api_id = var.api_id
  parent_id   = var.parent_id
  path_part   = var.path_part
}

module "cors" {
  source = "../cors-preflight"

  api_id          = var.api_id
  resource_id     = aws_api_gateway_resource.this.id
  allowed_methods = var.cors_methods
  allowed_headers = var.cors_headers
  allowed_origin  = var.cors_origin
}

module "lambda_integration" {
  source = "../lambda-integration"

  api_id               = var.api_id
  resource_id          = aws_api_gateway_resource.this.id
  http_method          = var.http_method
  lambda_invoke_arn    = var.lambda_invoke_arn
  lambda_function_name = var.lambda_function_name
  api_execution_arn    = var.api_execution_arn
  authorization        = var.authorization
  authorizer_id        = var.authorizer_id
  request_validator_id = var.request_validator_id
  request_model_name   = var.request_model_name
  cors_origin          = var.cors_origin
}
