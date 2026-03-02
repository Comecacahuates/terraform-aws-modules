locals {
  common_tags = merge(
    var.tags,
    {
      Environment = var.environment
    }
  )
}

resource "aws_dynamodb_table" "this" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "PK"
  range_key    = "SK"

  attribute {
    name = "PK"
    type = "S"
  }

  attribute {
    name = "SK"
    type = "S"
  }

  dynamic "attribute" {
    for_each = var.enable_gsi1 ? [1] : []
    content {
      name = "GSI1PK"
      type = "S"
    }
  }

  dynamic "attribute" {
    for_each = var.enable_gsi1 ? [1] : []
    content {
      name = "GSI1SK"
      type = "S"
    }
  }

  dynamic "global_secondary_index" {
    for_each = var.enable_gsi1 ? [1] : []
    content {
      name = "GSI1"
      key_schema {
        attribute_name = "GSI1PK"
        key_type       = "HASH"
      }
      key_schema {
        attribute_name = "GSI1SK"
        key_type       = "RANGE"
      }
      projection_type = "ALL"
    }
  }

  point_in_time_recovery {
    enabled = var.enable_point_in_time_recovery != null ? var.enable_point_in_time_recovery : var.environment == "production"
  }

  lifecycle {
    prevent_destroy = var.prevent_destroy
  }

  tags = local.common_tags
}
