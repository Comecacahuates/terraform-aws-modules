variable "api_id" {
  description = "API Gateway REST API ID"
  type        = string
}

variable "resource_id" {
  description = "API Gateway resource ID"
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

variable "api_execution_arn" {
  description = "API Gateway execution ARN for Lambda permissions"
  type        = string
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
  description = "Request model name for validation (if model already exists)"
  type        = string
  default     = null
}

variable "request_model_schema" {
  description = "JSON schema for request validation (creates model if provided)"
  type        = string
  default     = null
}

variable "cors_origin" {
  description = "CORS allowed origin for response headers"
  type        = string
  default     = "*"
}
