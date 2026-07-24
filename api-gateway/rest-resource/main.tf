resource "aws_api_gateway_resource" "this" {
  rest_api_id = var.api_id
  parent_id   = var.parent_id
  path_part   = var.path_part
}

resource "aws_api_gateway_method" "options" {
  count = var.cors_enabled ? 1 : 0

  rest_api_id   = var.api_id
  resource_id   = aws_api_gateway_resource.this.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "options" {
  count = var.cors_enabled ? 1 : 0

  rest_api_id = var.api_id
  resource_id = aws_api_gateway_resource.this.id
  http_method = aws_api_gateway_method.options[0].http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_method_response" "options" {
  count = var.cors_enabled ? 1 : 0

  rest_api_id = var.api_id
  resource_id = aws_api_gateway_resource.this.id
  http_method = aws_api_gateway_method.options[0].http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "options" {
  count = var.cors_enabled ? 1 : 0

  depends_on = [aws_api_gateway_method_response.options]

  rest_api_id = var.api_id
  resource_id = aws_api_gateway_resource.this.id
  http_method = aws_api_gateway_method.options[0].http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'${var.cors_headers}'"
    "method.response.header.Access-Control-Allow-Methods" = "'${var.cors_methods}'"
    "method.response.header.Access-Control-Allow-Origin"  = "'${var.cors_origin}'"
  }
}
