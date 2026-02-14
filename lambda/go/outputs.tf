output "function_name" {
  description = "Name of the Lambda function"
  value       = module.lambda.function_name
}

output "function_arn" {
  description = "ARN of the Lambda function"
  value       = module.lambda.function_arn
}

output "invoke_arn" {
  description = "Invoke ARN of the Lambda function"
  value       = module.lambda.invoke_arn
}

output "role_arn" {
  description = "ARN of the IAM role"
  value       = module.lambda.role_arn
}

output "role_name" {
  description = "Name of the IAM role"
  value       = module.lambda.role_name
}

output "log_group_name" {
  description = "Name of the CloudWatch log group"
  value       = module.lambda.log_group_name
}
