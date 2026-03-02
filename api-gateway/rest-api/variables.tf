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

variable "usage_plan_description" {
  description = "Description for the usage plan"
  type        = string
  default     = null
}

variable "usage_plan_quota_limit" {
  description = "Maximum number of requests per quota period"
  type        = number
  default     = 10000
}

variable "usage_plan_quota_period" {
  description = "Quota period (DAY, WEEK, MONTH)"
  type        = string
  default     = "MONTH"
}

variable "usage_plan_burst_limit" {
  description = "API request burst limit"
  type        = number
  default     = 100
}

variable "usage_plan_rate_limit" {
  description = "API request steady-state rate limit (requests per second)"
  type        = number
  default     = 50
}

variable "api_key_name" {
  description = "Name for API key (creates key if provided)"
  type        = string
  default     = null
}
