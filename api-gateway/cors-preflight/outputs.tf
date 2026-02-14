output "method_id" {
  description = "OPTIONS method ID"
  value       = aws_api_gateway_method.options.id
}

output "integration_id" {
  description = "OPTIONS integration ID"
  value       = aws_api_gateway_integration.options.id
}
