# Go Lambda Module

Preconfigured AWS Lambda function for Go applications with standard runtime settings.

This module wraps the `lambda/standard` module with Go-specific defaults:
- **Handler**: `bootstrap` (Go custom runtime)
- **Runtime**: `provided.al2023` (Amazon Linux 2023)
- **Memory**: 256 MB (better default for Go than 128 MB)

## Features

- Optimized defaults for Go Lambda functions
- No need to specify handler or runtime
- Includes IAM role, CloudWatch logs, and custom permissions
- All benefits of the standard Lambda module

## Usage

```hcl
module "my_go_lambda" {
  source = "git::https://github.com/Comecacahuates/terraform-aws-modules.git//lambda/go?ref=v1.3.0"

  function_name = "my-go-function"
  source_file   = "path/to/bootstrap.zip"

  memory_size = 256
  timeout     = 10

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

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| function_name | Name of the Lambda function | string | - | yes |
| source_file | Path to the Lambda deployment package (Go binary zip) | string | - | yes |
| memory_size | Amount of memory in MB | number | 256 | no |
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

## Go Binary Requirements

Your Go binary must be:
1. Compiled for Linux AMD64: `GOOS=linux GOARCH=amd64 go build -o bootstrap`
2. Zipped: `zip bootstrap.zip bootstrap`
3. Use AWS Lambda Go SDK: `github.com/aws/aws-lambda-go/lambda`

## Example Go Handler

```go
package main

import (
    "context"
    "github.com/aws/aws-lambda-go/lambda"
)

type Event struct {
    Name string `json:"name"`
}

type Response struct {
    Message string `json:"message"`
}

func handler(ctx context.Context, event Event) (Response, error) {
    return Response{
        Message: "Hello " + event.Name,
    }, nil
}

func main() {
    lambda.Start(handler)
}
```

## Differences from Standard Module

- **Handler**: Fixed to `bootstrap` (no need to specify)
- **Runtime**: Fixed to `provided.al2023` (no need to specify)
- **Memory**: Default 256 MB instead of 128 MB (better for Go)
- Everything else is the same as `lambda/standard`

## See Also

- [lambda/standard](../standard/README.md) - Generic Lambda module for any runtime
