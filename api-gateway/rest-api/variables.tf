variable "api_name" {
  description = "Name of the API Gateway REST API"
  type        = string
}

variable "environment" {
  description = "Environment name (used for stage name and log retention defaults)"
  type        = string
}

variable "description" {
  description = "Description of the API Gateway"
  type        = string
  default     = null
}

variable "deployment_triggers" {
  description = "Map of values that trigger redeployment when changed"
  type        = map(string)
  default     = {}
}

variable "log_retention_days" {
  description = "CloudWatch log retention in days (defaults to 90 for production, 14 otherwise)"
  type        = number
  default     = null
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
