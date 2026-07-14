# ==============================================================================
# Required
# ==============================================================================

variable "name" {
  description = "Base name for all resources (Lambda function, SNS subscription)"
  type        = string
}

variable "source_file" {
  description = "Path to the Lambda deployment package (zip file)"
  type        = string
}

variable "sns_topic_arn" {
  description = "ARN of the SNS topic to subscribe to"
  type        = string
}

variable "environment_variables" {
  description = "Environment variables for the Lambda function"
  type        = map(string)
}

variable "policy_statements" {
  description = "IAM policy statements for the Lambda execution role"
  type = list(object({
    Action   = list(string)
    Resource = list(string)
  }))
}

# ==============================================================================
# Optional — Lambda
# ==============================================================================

variable "memory_size" {
  description = "Lambda memory in MB"
  type        = number
  default     = 128
}

variable "timeout" {
  description = "Lambda timeout in seconds"
  type        = number
  default     = 10
}

# ==============================================================================
# Optional — Monitoring
# ==============================================================================

variable "alert_topic_arn" {
  description = "ARN of the SNS topic for DLQ alarm notifications"
  type        = string
  default     = null
}

# ==============================================================================
# Optional — Dead Letter Queue
# ==============================================================================

variable "dead_letter_queue" {
  description = "DLQ configuration for the SNS subscription. Set to null to disable."
  type = object({
    retention_days = optional(number, 14)
  })
  default = null
}

# ==============================================================================
# Optional — Tags
# ==============================================================================

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
