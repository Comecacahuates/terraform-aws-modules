# ==============================================================================
# EventBridge Rule + Target + Permission
# ==============================================================================

resource "aws_cloudwatch_event_rule" "this" {
  name           = "${var.name}-rule"
  description    = "Trigger ${var.name}"
  event_bus_name = var.event_bus_name
  event_pattern  = var.event_pattern

  tags = var.tags
}

resource "aws_cloudwatch_event_target" "this" {
  rule           = aws_cloudwatch_event_rule.this.name
  event_bus_name = var.event_bus_name
  target_id      = "${var.name}-target"
  arn            = aws_lambda_function.this.arn

  dynamic "dead_letter_config" {
    for_each = var.dead_letter_queue != null ? [1] : []
    content {
      arn = aws_sqs_queue.dlq[0].arn
    }
  }

  dynamic "retry_policy" {
    for_each = var.dead_letter_queue != null ? [1] : []
    content {
      maximum_retry_attempts       = var.dead_letter_queue.max_retries
      maximum_event_age_in_seconds = var.dead_letter_queue.max_age_seconds
    }
  }
}

resource "aws_lambda_permission" "eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.this.arn
}
