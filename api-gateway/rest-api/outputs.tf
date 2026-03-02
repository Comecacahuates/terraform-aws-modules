output "api_id" {
  description = "ID of the API Gateway REST API"
  value       = aws_api_gateway_rest_api.this.id
}

output "api_arn" {
  description = "ARN of the API Gateway REST API"
  value       = aws_api_gateway_rest_api.this.arn
}

output "execution_arn" {
  description = "Execution ARN of the API Gateway (for Lambda permissions)"
  value       = aws_api_gateway_rest_api.this.execution_arn
}

output "root_resource_id" {
  description = "Root resource ID of the API Gateway"
  value       = aws_api_gateway_rest_api.this.root_resource_id
}

output "stage_name" {
  description = "Name of the API Gateway stage"
  value       = aws_api_gateway_stage.this.stage_name
}

output "invoke_url" {
  description = "Invoke URL of the API Gateway stage"
  value       = aws_api_gateway_stage.this.invoke_url
}

output "usage_plan_id" {
  description = "ID of the usage plan"
  value       = aws_api_gateway_usage_plan.this.id
}

output "api_key_id" {
  description = "ID of the API key (if created)"
  value       = var.api_key_name != null ? aws_api_gateway_api_key.this[0].id : null
}

output "api_key_value" {
  description = "Value of the API key (if created)"
  value       = var.api_key_name != null ? aws_api_gateway_api_key.this[0].value : null
  sensitive   = true
}
