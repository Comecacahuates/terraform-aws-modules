output "method_id" {
  description = "API Gateway method ID"
  value       = aws_api_gateway_method.this.id
}

output "http_method" {
  description = "HTTP method"
  value       = aws_api_gateway_method.this.http_method
}
