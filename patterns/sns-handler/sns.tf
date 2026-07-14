# ==============================================================================
# SNS Subscription + Lambda Permission
# ==============================================================================

resource "aws_sns_topic_subscription" "this" {
  topic_arn = var.sns_topic_arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.this.arn

  redrive_policy = var.dead_letter_queue != null ? jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq[0].arn
  }) : null
}

resource "aws_lambda_permission" "sns" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = var.sns_topic_arn
}
