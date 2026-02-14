# Lambda Standard Module

Complete AWS Lambda function setup with IAM role, CloudWatch logs, and custom permissions.

## Features

- Lambda function with configurable runtime and handler
- IAM execution role with assume role policy
- CloudWatch log group with configurable retention
- Custom IAM policy statements support
- Basic execution role (CloudWatch Logs) attached automatically
- Proper dependency management

## Usage

```hcl
module "my_lambda" {
  source = "git::https://github.com/Comecacahuates/terraform-aws-modules.git//lambda-standard?ref=v1.3.0"

  function_name = "my-function"
  handler       = "index.handler"
  runtime       = "nodejs20.x"
  source_file   = "path/to/deployment.zip"

  memory_size        = 256
  timeout            = 30
  log_retention_days = 14

  environment_variables = {
    ENVIRONMENT = "production"
    TABLE_NAME  = "my-table"
  }

  policy_statements = [
    {
      Action   = ["dynamodb:GetItem", "dynamodb:PutItem"]
      Resource = ["arn:aws:dynamodb:us-east-1:123456789:table/my-table"]
    }
  ]

  tags = {
    Project     = "my-project"
    Environment = "production"
  }
}
```

## Go Lambda Example

```hcl
module "go_lambda" {
  source = "git::https://github.com/Comecacahuates/terraform-aws-modules.git//lambda-standard?ref=v1.3.0"

  function_name = "my-go-function"
  handler       = "bootstrap"
  runtime       = "provided.al2023"
  source_file   = "path/to/bootstrap.zip"

  memory_size = 256
  timeout     = 10

  environment_variables = {
    ENVIRONMENT = "production"
  }

  policy_statements = [
    {
      Action   = ["s3:GetObject"]
      Resource = ["arn:aws:s3:::my-bucket/*"]
    }
  ]

  tags = {
    Project = "my-project"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| function_name | Name of the Lambda function | string | - | yes |
| handler | Lambda function handler | string | - | yes |
| runtime | Lambda runtime | string | - | yes |
| source_file | Path to the Lambda deployment package | string | - | yes |
| memory_size | Amount of memory in MB | number | 128 | no |
| timeout | Timeout in seconds | number | 10 | no |
| log_retention_days | CloudWatch log retention in days | number | 7 | no |
| environment_variables | Environment variables for the Lambda function | map(string) | {} | no |
| policy_statements | IAM policy statements for Lambda permissions | list(object) | [] | no |
| tags | Tags to apply to all resources | map(string) | {} | no |

## Outputs

| Name | Description |
|------|-------------|
| function_name | Name of the Lambda function |
| function_arn | ARN of the Lambda function |
| invoke_arn | Invoke ARN of the Lambda function |
| role_arn | ARN of the IAM role |
| role_name | Name of the IAM role |
| log_group_name | Name of the CloudWatch log group |

## Resources Created

- `aws_lambda_function` - The Lambda function
- `aws_iam_role` - Lambda execution role
- `aws_iam_role_policy_attachment` - Basic execution role (CloudWatch Logs)
- `aws_iam_role_policy` - Custom permissions (if policy_statements provided)
- `aws_cloudwatch_log_group` - Lambda logs

## Notes

- The IAM role name will be the same as the function name
- CloudWatch log group is created before the Lambda function
- Basic execution role (AWSLambdaBasicExecutionRole) is automatically attached
- Custom policy statements are optional and only created if provided
