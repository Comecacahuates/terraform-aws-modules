variable "api_id" {
  description = "API Gateway REST API ID"
  type        = string
}

variable "resource_id" {
  description = "API Gateway resource ID"
  type        = string
}

variable "allowed_methods" {
  description = "Allowed HTTP methods"
  type        = string
  default     = "GET,POST,PUT,DELETE,OPTIONS"
}

variable "allowed_origin" {
  description = "Allowed origin for CORS"
  type        = string
  default     = "*"
}
