variable "table_name" {
  description = "Name of the DynamoDB table"
  type        = string
}

variable "environment" {
  description = "Environment name (used for point-in-time recovery default)"
  type        = string
}

variable "enable_gsi1" {
  description = "Enable GSI1 with GSI1PK and GSI1SK"
  type        = bool
  default     = true
}

variable "enable_point_in_time_recovery" {
  description = "Enable point-in-time recovery (defaults to true for production environment)"
  type        = bool
  default     = null
}

variable "prevent_destroy" {
  description = "Prevent table from being destroyed (recommended for production)"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to the table"
  type        = map(string)
  default     = {}
}
