# API Gateway Lambda Integration Module

Connects an API Gateway method to a Lambda function with CORS configured in infrastructure.

## Features

- AWS integration (not AWS_PROXY) for infrastructure-controlled responses
- CORS headers configured in Terraform
- Configurable authorization (NONE, AWS_IAM, CUSTOM, COGNITO_USER_POOLS)
- Request validation support
- Lambda invoke permissions

## Usage

```hcl
module "lambda_integration" {
  source = "git::https://github.com/Comecacahuates/terraform-aws-modules.git//api-gateway/lambda-integration?ref=v1.0.0"
  
  api_id               = aws_api_gateway_rest_api.api.id
  resource_id          = aws_api_gateway_resource.resource.id
  http_method          = "POST"
  lambda_invoke_arn    = aws_lambda_function.handler.invoke_arn
  lambda_function_name = aws_lambda_function.handler.function_name
  api_execution_arn    = aws_api_gateway_rest_api.api.execution_arn
}
```

## With Custom CORS

```hcl
module "lambda_integration" {
  source = "git::https://github.com/Comecacahuates/terraform-aws-modules.git//api-gateway/lambda-integration?ref=v1.0.0"
  
  api_id               = aws_api_gateway_rest_api.api.id
  resource_id          = aws_api_gateway_resource.resource.id
  http_method          = "POST"
  lambda_invoke_arn    = aws_lambda_function.handler.invoke_arn
  lambda_function_name = aws_lambda_function.handler.function_name
  api_execution_arn    = aws_api_gateway_rest_api.api.execution_arn
  cors_origin          = "https://example.com"
}
```

## Requirements

- Terraform >= 1.0
- AWS Provider >= 6.0

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| api_id | API Gateway REST API ID | string | n/a | yes |
| resource_id | API Gateway resource ID | string | n/a | yes |
| http_method | HTTP method | string | n/a | yes |
| lambda_invoke_arn | Lambda function invoke ARN | string | n/a | yes |
| lambda_function_name | Lambda function name | string | n/a | yes |
| api_execution_arn | API Gateway execution ARN | string | n/a | yes |
| authorization | Authorization type | string | NONE | no |
| authorizer_id | Authorizer ID | string | null | no |
| request_validator_id | Request validator ID | string | null | no |
| request_model_name | Request model name | string | null | no |
| cors_origin | CORS origin for response headers | string | * | no |

## Outputs

| Name | Description |
|------|-------------|
| method_id | API Gateway method ID |
| integration_id | API Gateway integration ID |

## Notes

- Uses AWS integration (not AWS_PROXY) - API Gateway controls response format
- CORS headers are configured in Terraform, not in Lambda code
- Lambda should return simple JSON response without status codes or headers
- Lambda permission statement_id is unique per resource and method
