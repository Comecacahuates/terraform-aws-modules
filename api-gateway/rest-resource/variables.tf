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

variable "cors_enabled" {
  description = "Enable CORS preflight (OPTIONS method)"
  type        = bool
  default     = true
}

variable "cors_origin" {
  description = "CORS allowed origin"
  type        = string
  default     = "*"
}

variable "cors_methods" {
  description = "CORS allowed methods"
  type        = string
  default     = "GET,POST,PUT,DELETE,OPTIONS"
}

variable "cors_headers" {
  description = "CORS allowed headers"
  type        = string
  default     = "Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token"
}
