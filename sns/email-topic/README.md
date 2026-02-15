# SNS Email Topic Module

Creates an SNS topic with email subscriptions.

## Features

- SNS topic with configurable name and display name
- Multiple email subscriptions
- Email subscribers must confirm subscription via email

## Usage

```hcl
module "alerts_topic" {
  source = "git::https://github.com/Comecacahuates/terraform-aws-modules.git//sns/email-topic?ref=v1.4.0"
  
  topic_name   = "application-alerts"
  display_name = "Application Alerts"
  
  email_addresses = [
    "admin@example.com",
    "team@example.com"
  ]
  
  tags = {
    Environment = "production"
    Purpose     = "alerts"
  }
}
```

## Single Email Subscription

```hcl
module "notifications" {
  source = "git::https://github.com/Comecacahuates/terraform-aws-modules.git//sns/email-topic?ref=v1.4.0"
  
  topic_name = "user-notifications"
  
  email_addresses = ["notifications@example.com"]
}
```

## Requirements

- Terraform >= 1.0
- AWS Provider >= 6.0

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| topic_name | Name of the SNS topic | string | n/a | yes |
| display_name | Display name for the SNS topic | string | null | no |
| email_addresses | List of email addresses to subscribe | list(string) | [] | no |
| tags | Tags to apply to the SNS topic | map(string) | {} | no |

## Outputs

| Name | Description |
|------|-------------|
| topic_arn | ARN of the SNS topic |
| topic_name | Name of the SNS topic |
| topic_id | ID of the SNS topic |
| subscription_arns | ARNs of the email subscriptions |

## Notes

- Email subscribers will receive a confirmation email from AWS
- Subscriptions are not active until confirmed by the recipient
- Each email address creates a separate subscription
- Removing an email from the list will delete the subscription
- Topic can be used without email subscriptions (empty list)

## Publishing Messages

After creating the topic, publish messages using AWS SDK or CLI:

```bash
aws sns publish \
  --topic-arn <topic-arn> \
  --subject "Alert" \
  --message "Something happened"
```

Or from Lambda/application code:
```python
import boto3

sns = boto3.client('sns')
sns.publish(
    TopicArn='arn:aws:sns:...',
    Subject='Alert',
    Message='Something happened'
)
```
