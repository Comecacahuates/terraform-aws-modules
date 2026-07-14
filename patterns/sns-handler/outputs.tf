output "function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.this.function_name
}

output "function_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.this.arn
}

output "dlq_arn" {
  description = "ARN of the dead-letter queue (null if DLQ disabled)"
  value       = var.dead_letter_queue != null ? aws_sqs_queue.dlq[0].arn : null
}

output "dlq_url" {
  description = "URL of the dead-letter queue (null if DLQ disabled)"
  value       = var.dead_letter_queue != null ? aws_sqs_queue.dlq[0].id : null
}
