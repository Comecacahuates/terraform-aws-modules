# API Gateway CORS Preflight Module

Configures CORS preflight (OPTIONS method) for API Gateway resources.

## Features

- OPTIONS method with MOCK integration
- Configurable allowed methods, headers, and origin
- No Lambda function required

## Usage

```hcl
module "cors" {
  source = "git::https://github.com/Comecacahuates/terraform-aws-modules.git//api-gateway/cors-preflight?ref=v1.0.0"
  
  api_id      = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.resource.id
}
```

## Custom Configuration

```hcl
module "cors" {
  source = "git::https://github.com/Comecacahuates/terraform-aws-modules.git//api-gateway/cors-preflight?ref=v1.0.0"
  
  api_id          = aws_api_gateway_rest_api.api.id
  resource_id     = aws_api_gateway_resource.resource.id
  allowed_methods = "GET,POST,OPTIONS"
  allowed_origin  = "https://example.com"
  allowed_headers = "Content-Type,Authorization"
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
| allowed_methods | Allowed HTTP methods | string | GET,POST,PUT,DELETE,OPTIONS | no |
| allowed_headers | Allowed headers for CORS | string | Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token | no |
| allowed_origin | Allowed origin for CORS | string | * | no |

## Outputs

| Name | Description |
|------|-------------|
| method_id | OPTIONS method ID |
| integration_id | OPTIONS integration ID |

## Notes

- Uses MOCK integration (no backend required)
- Returns 200 status code with CORS headers
- Should be used with lambda-integration or other method modules
