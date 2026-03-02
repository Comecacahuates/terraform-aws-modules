output "table_name" {
  description = "Name of the DynamoDB table"
  value       = aws_dynamodb_table.this.name
}

output "table_arn" {
  description = "ARN of the DynamoDB table"
  value       = aws_dynamodb_table.this.arn
}

output "gsi1_name" {
  description = "Name of GSI1 (null if not enabled)"
  value       = var.enable_gsi1 ? "GSI1" : null
}
