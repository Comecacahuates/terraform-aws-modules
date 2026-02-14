variable "api_id" {
  description = "API Gateway REST API ID"
  type        = string
}

variable "resource_id" {
  description = "API Gateway resource ID"
  type        = string
}

variable "http_method" {
  description = "HTTP method"
  type        = string
}

variable "lambda_invoke_arn" {
  description = "Lambda function invoke ARN"
  type        = string
}

variable "lambda_function_name" {
  description = "Lambda function name"
  type        = string
}

variable "api_execution_arn" {
  description = "API Gateway execution ARN"
  type        = string
}

variable "authorization" {
  description = "Authorization type"
  type        = string
  default     = "NONE"
}

variable "authorizer_id" {
  description = "Authorizer ID"
  type        = string
  default     = null
}

variable "request_validator_id" {
  description = "Request validator ID"
  type        = string
  default     = null
}

variable "request_model_name" {
  description = "Request model name"
  type        = string
  default     = null
}

variable "cors_origin" {
  description = "CORS origin for response"
  type        = string
  default     = "*"
}
