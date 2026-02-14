variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]*[a-z0-9]$", var.bucket_name))
    error_message = "Bucket name must be lowercase alphanumeric with hyphens, and cannot start or end with a hyphen"
  }
}

variable "domain_name" {
  description = "Custom domain name (optional)"
  type        = string
  default     = null
}

variable "acm_certificate_arn" {
  description = "ARN of ACM certificate for custom domain (required if domain_name is set)"
  type        = string
  default     = null
}

variable "price_class" {
  description = "CloudFront price class"
  type        = string
  default     = "PriceClass_100"
}

variable "default_root_object" {
  description = "Default root object"
  type        = string
  default     = "index.html"
}

variable "enable_spa_routing" {
  description = "Enable SPA routing (404/403 errors return index.html)"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
