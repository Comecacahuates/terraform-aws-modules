# API Gateway Endpoint Module

Reusable module for creating REST API Gateway endpoints with Lambda integration and CORS support.

## Features

- Creates API Gateway resource
- Configures CORS OPTIONS method automatically
- Sets up Lambda integration with AWS_PROXY
- Configures Lambda permissions
- Supports request validation
- Supports authorization (NONE, AWS_IAM, COGNITO_USER_POOLS)

## Usage

### Basic endpoint (no validation)

```hcl
module "get_leads" {
  source = "../../shared/api_gateway_endpoint"

  api_id              = aws_api_gateway_rest_api.backoffice.id
  parent_id           = aws_api_gateway_rest_api.backoffice.root_resource_id
  path_part           = "leads"
  http_method         = "GET"
  lambda_invoke_arn   = var.lambda_api_get_leads.invoke_arn
  lambda_function_name = var.lambda_api_get_leads.function_name
  api_execution_arn   = aws_api_gateway_rest_api.backoffice.execution_arn
  cors_origin         = "*"
}
```

### Endpoint with validation

```hcl
resource "aws_api_gateway_request_validator" "create_lead" {
  rest_api_id           = aws_api_gateway_rest_api.website.id
  name                  = "create-lead-validator"
  validate_request_body = true
}

resource "aws_api_gateway_model" "create_lead" {
  rest_api_id  = aws_api_gateway_rest_api.website.id
  name         = "CreateLeadModel"
  content_type = "application/json"
  schema       = var.lambda_api_create_lead.validation_schema
}

module "create_lead" {
  source = "../../shared/api_gateway_endpoint"

  api_id               = aws_api_gateway_rest_api.website.id
  parent_id            = aws_api_gateway_rest_api.website.root_resource_id
  path_part            = "leads"
  http_method          = "POST"
  lambda_invoke_arn    = var.lambda_api_create_lead.invoke_arn
  lambda_function_name = var.lambda_api_create_lead.function_name
  api_execution_arn    = aws_api_gateway_rest_api.website.execution_arn
  cors_origin          = var.cors_allowed_origin
  request_validator_id = aws_api_gateway_request_validator.create_lead.id
  request_model_name   = aws_api_gateway_model.create_lead.name
}
```

### Endpoint with authorization

```hcl
module "admin_endpoint" {
  source = "../../shared/api_gateway_endpoint"

  api_id               = aws_api_gateway_rest_api.backoffice.id
  parent_id            = aws_api_gateway_rest_api.backoffice.root_resource_id
  path_part            = "admin"
  http_method          = "POST"
  lambda_invoke_arn    = var.lambda_admin.invoke_arn
  lambda_function_name = var.lambda_admin.function_name
  api_execution_arn    = aws_api_gateway_rest_api.backoffice.execution_arn
  authorization        = "COGNITO_USER_POOLS"
  authorizer_id        = aws_api_gateway_authorizer.cognito.id
}
```

## Benefits

**Before (140+ lines per endpoint):**
```hcl
resource "aws_api_gateway_resource" "leads" { ... }
resource "aws_api_gateway_method" "leads_options" { ... }
resource "aws_api_gateway_integration" "leads_options" { ... }
resource "aws_api_gateway_method_response" "leads_options" { ... }
resource "aws_api_gateway_integration_response" "leads_options" { ... }
resource "aws_api_gateway_method" "create_lead" { ... }
resource "aws_api_gateway_integration" "create_lead" { ... }
resource "aws_api_gateway_method_response" "create_lead" { ... }
resource "aws_api_gateway_integration_response" "create_lead" { ... }
resource "aws_lambda_permission" "create_lead" { ... }
```

**After (10 lines per endpoint):**
```hcl
module "create_lead" {
  source = "../../shared/api_gateway_endpoint"
  
  api_id               = aws_api_gateway_rest_api.website.id
  parent_id            = aws_api_gateway_rest_api.website.root_resource_id
  path_part            = "leads"
  http_method          = "POST"
  lambda_invoke_arn    = var.lambda_api_create_lead.invoke_arn
  lambda_function_name = var.lambda_api_create_lead.function_name
  api_execution_arn    = aws_api_gateway_rest_api.website.execution_arn
}
```

**Savings: ~93% less code per endpoint**
