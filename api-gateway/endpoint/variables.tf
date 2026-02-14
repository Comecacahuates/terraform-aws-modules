variable "api_id" {
  description = "API Gateway REST API ID"
  type        = string
}

variable "parent_id" {
  description = "Parent resource ID"
  type        = string
}

variable "path_part" {
  description = "Path segment for this resource"
  type        = string
}

variable "http_method" {
  description = "HTTP method (GET, POST, PUT, DELETE, etc.)"
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

variable "cors_origin" {
  description = "CORS allowed origin"
  type        = string
  default     = "*"
}

variable "authorization" {
  description = "Authorization type (NONE, AWS_IAM, CUSTOM, COGNITO_USER_POOLS)"
  type        = string
  default     = "NONE"
}

variable "authorizer_id" {
  description = "Authorizer ID (if using CUSTOM or COGNITO_USER_POOLS)"
  type        = string
  default     = null
}

variable "request_validator_id" {
  description = "Request validator ID"
  type        = string
  default     = null
}

variable "request_model_name" {
  description = "Request model name for validation"
  type        = string
  default     = null
}

variable "api_execution_arn" {
  description = "API Gateway execution ARN for Lambda permissions"
  type        = string
}
