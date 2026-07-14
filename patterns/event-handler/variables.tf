# ==============================================================================
# Required
# ==============================================================================

variable "name" {
  description = "Base name for all resources (Lambda function, EventBridge rule, DLQ)"
  type        = string
}

variable "source_file" {
  description = "Path to the Lambda deployment package (zip file)"
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

variable "event_bus_name" {
  description = "Name of the EventBridge event bus"
  type        = string
}

variable "event_pattern" {
  description = "EventBridge event pattern as JSON string"
  type        = string
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
  description = "ARN of the SNS topic for alarm notifications. Required if dead_letter_queue is set."
  type        = string
  default     = null
}

# ==============================================================================
# Optional — Dead Letter Queue
# ==============================================================================

variable "dead_letter_queue" {
  description = "DLQ configuration. Set to null to disable."
  type = object({
    max_retries     = optional(number, 3)
    max_age_seconds = optional(number, 3600)
    retention_days  = optional(number, 14)
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
