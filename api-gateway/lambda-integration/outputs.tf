output "method_id" {
  description = "API Gateway method ID"
  value       = aws_api_gateway_method.this.id
}

output "integration_id" {
  description = "API Gateway integration ID"
  value       = aws_api_gateway_integration.this.id
}
