locals {
  common_tags = merge(
    var.tags,
    {
      Environment = var.environment
    }
  )
  
  log_retention_days = var.log_retention_days != null ? var.log_retention_days : (var.environment == "production" ? 90 : 14)
}

resource "aws_api_gateway_rest_api" "this" {
  name        = var.api_name
  description = var.description

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  tags = local.common_tags
}

resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id

  triggers = var.deployment_triggers

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "this" {
  deployment_id = aws_api_gateway_deployment.this.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
  stage_name    = var.environment

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.this.arn
    format = jsonencode({
      requestId      = "$context.requestId"
      ip             = "$context.identity.sourceIp"
      requestTime    = "$context.requestTime"
      httpMethod     = "$context.httpMethod"
      resourcePath   = "$context.resourcePath"
      status         = "$context.status"
      protocol       = "$context.protocol"
      responseLength = "$context.responseLength"
    })
  }

  tags = local.common_tags
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/apigateway/${var.api_name}"
  retention_in_days = local.log_retention_days

  tags = local.common_tags
}
