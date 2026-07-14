# ==============================================================================
# Dead Letter Queue + Policy + CloudWatch Alarm (conditional)
# ==============================================================================

resource "aws_sqs_queue" "dlq" {
  count = var.dead_letter_queue != null ? 1 : 0

  name                      = "${var.name}-dlq"
  message_retention_seconds = var.dead_letter_queue.retention_days * 86400

  tags = var.tags
}

data "aws_iam_policy_document" "dlq" {
  count = var.dead_letter_queue != null ? 1 : 0

  statement {
    effect    = "Allow"
    actions   = ["sqs:SendMessage"]
    resources = [aws_sqs_queue.dlq[0].arn]

    principals {
      type        = "Service"
      identifiers = ["sns.amazonaws.com"]
    }

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [var.sns_topic_arn]
    }
  }
}

resource "aws_sqs_queue_policy" "dlq" {
  count = var.dead_letter_queue != null ? 1 : 0

  queue_url = aws_sqs_queue.dlq[0].id
  policy    = data.aws_iam_policy_document.dlq[0].json
}

resource "aws_cloudwatch_metric_alarm" "dlq" {
  count = var.dead_letter_queue != null && var.alert_topic_arn != null ? 1 : 0

  alarm_name          = "${var.name}-dlq-messages"
  alarm_description   = "Messages in DLQ for ${var.name}"
  namespace           = "AWS/SQS"
  metric_name         = "ApproximateNumberOfMessagesVisible"
  statistic           = "Maximum"
  period              = 60
  evaluation_periods  = 1
  threshold           = 1
  comparison_operator = "GreaterThanOrEqualToThreshold"
  treat_missing_data  = "notBreaching"

  dimensions = {
    QueueName = aws_sqs_queue.dlq[0].name
  }

  alarm_actions = [var.alert_topic_arn]
  ok_actions    = [var.alert_topic_arn]

  tags = var.tags
}
