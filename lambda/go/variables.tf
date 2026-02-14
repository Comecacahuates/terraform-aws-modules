variable "function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "source_file" {
  description = "Path to the Lambda deployment package (Go binary zip)"
  type        = string
}

variable "memory_size" {
  description = "Amount of memory in MB"
  type        = number
  default     = 256
}

variable "timeout" {
  description = "Timeout in seconds"
  type        = number
  default     = 10
}

variable "log_retention_days" {
  description = "CloudWatch log retention in days"
  type        = number
  default     = 7
}

variable "environment_variables" {
  description = "Environment variables for the Lambda function"
  type        = map(string)
  default     = {}
}

variable "policy_statements" {
  description = "IAM policy statements for Lambda permissions"
  type = list(object({
    Effect   = optional(string, "Allow")
    Action   = list(string)
    Resource = list(string)
  }))
  default = []
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
