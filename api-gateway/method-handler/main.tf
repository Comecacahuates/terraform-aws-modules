resource "aws_api_gateway_request_validator" "this" {
  count = var.request_model_schema != null ? 1 : 0

  rest_api_id           = var.api_id
  name                  = "${var.http_method}-${var.resource_id}-validator"
  validate_request_body = true
}

resource "aws_api_gateway_model" "this" {
  count = var.request_model_schema != null ? 1 : 0

  rest_api_id  = var.api_id
  name         = replace("${var.http_method}${var.resource_id}Model", "/[^a-zA-Z0-9]/", "")
  content_type = "application/json"
  schema       = var.request_model_schema
}

resource "aws_api_gateway_method" "this" {
  rest_api_id          = var.api_id
  resource_id          = var.resource_id
  http_method          = var.http_method
  authorization        = var.authorization
  authorizer_id        = var.authorizer_id
  api_key_required     = var.api_key_required
  request_validator_id = var.request_model_schema != null ? aws_api_gateway_request_validator.this[0].id : null

  request_models = var.request_model_schema != null ? {
    "application/json" = aws_api_gateway_model.this[0].name
  } : null
}

resource "aws_api_gateway_integration" "this" {
  rest_api_id             = var.api_id
  resource_id             = var.resource_id
  http_method             = aws_api_gateway_method.this.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn
}

resource "aws_api_gateway_method_response" "this" {
  rest_api_id = var.api_id
  resource_id = var.resource_id
  http_method = aws_api_gateway_method.this.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

resource "aws_api_gateway_integration_response" "this" {
  rest_api_id = var.api_id
  resource_id = var.resource_id
  http_method = aws_api_gateway_method.this.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'${var.cors_origin}'"
  }
}

resource "aws_lambda_permission" "this" {
  statement_id  = "AllowAPIGatewayInvoke-${var.resource_id}-${var.http_method}"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.api_execution_arn}/*/*"
}
