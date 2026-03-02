resource "aws_cloudwatch_event_rule" "this" {
  name           = var.rule_name
  description    = var.description
  event_bus_name = var.event_bus_name
  event_pattern  = var.event_pattern

  tags = var.tags
}

resource "aws_cloudwatch_event_target" "this" {
  rule           = aws_cloudwatch_event_rule.this.name
  event_bus_name = var.event_bus_name
  target_id      = "${var.rule_name}-target"
  arn            = var.lambda_function_arn
}

resource "aws_lambda_permission" "this" {
  statement_id  = "AllowExecutionFromEventBridge-${var.rule_name}"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.this.arn
}
