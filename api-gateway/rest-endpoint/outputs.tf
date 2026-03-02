output "resource_id" {
  description = "API Gateway resource ID"
  value       = aws_api_gateway_resource.this.id
}

output "resource_path" {
  description = "Full resource path"
  value       = aws_api_gateway_resource.this.path
}
