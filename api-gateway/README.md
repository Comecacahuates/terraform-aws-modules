# Decomposed API Gateway Modules

## Module Hierarchy

```
shared/
├── api_cors_preflight/          # Single responsibility: CORS OPTIONS
├── api_lambda_integration/      # Single responsibility: Lambda integration
└── api_gateway_endpoint/        # Composite: Uses above modules
```

## Design Principles

Following **Single Responsibility Principle** and **Composition over Monoliths**:

### 1. `api_cors_preflight` - CORS OPTIONS Method
**Responsibility:** Configure CORS preflight (OPTIONS method)

**Usage:**
```hcl
module "cors" {
  source = "../../shared/api_cors_preflight"
  
  api_id          = aws_api_gateway_rest_api.api.id
  resource_id     = aws_api_gateway_resource.resource.id
  allowed_methods = "GET,POST,OPTIONS"
  allowed_origin  = "*"
}
```

### 2. `api_lambda_integration` - Lambda Integration
**Responsibility:** Connect API Gateway method to Lambda function

**Usage:**
```hcl
module "lambda_integration" {
  source = "../../shared/api_lambda_integration"
  
  api_id               = aws_api_gateway_rest_api.api.id
  resource_id          = aws_api_gateway_resource.resource.id
  http_method          = "POST"
  lambda_invoke_arn    = aws_lambda_function.handler.invoke_arn
  lambda_function_name = aws_lambda_function.handler.function_name
  api_execution_arn    = aws_api_gateway_rest_api.api.execution_arn
  cors_origin          = "*"
}
```

### 3. `api_gateway_endpoint` - Composite Module
**Responsibility:** Combine resource + CORS + Lambda integration

**Usage:**
```hcl
module "endpoint" {
  source = "../../shared/api_gateway_endpoint"
  
  api_id               = aws_api_gateway_rest_api.api.id
  parent_id            = aws_api_gateway_rest_api.api.root_resource_id
  path_part            = "leads"
  http_method          = "POST"
  lambda_invoke_arn    = var.lambda.invoke_arn
  lambda_function_name = var.lambda.function_name
  api_execution_arn    = aws_api_gateway_rest_api.api.execution_arn
}
```

## Benefits of Decomposition

### Flexibility
- Use `api_cors_preflight` alone for non-Lambda endpoints
- Use `api_lambda_integration` alone when resource already exists
- Use `api_gateway_endpoint` for complete endpoint setup

### Testability
- Test CORS configuration independently
- Test Lambda integration independently
- Test composition separately

### Reusability
- CORS module works with any integration type (Lambda, HTTP, Mock)
- Lambda integration module works with existing resources
- Endpoint module provides convenience wrapper

### Maintainability
- Change CORS behavior in one place
- Change Lambda integration pattern in one place
- Composite module automatically gets updates

## Example: Mix and Match

```hcl
# Create resource manually
resource "aws_api_gateway_resource" "custom" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "custom"
}

# Add CORS
module "custom_cors" {
  source = "../../shared/api_cors_preflight"
  
  api_id      = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.custom.id
}

# Add multiple methods to same resource
module "get_custom" {
  source = "../../shared/api_lambda_integration"
  
  api_id            = aws_api_gateway_rest_api.api.id
  resource_id       = aws_api_gateway_resource.custom.id
  http_method       = "GET"
  lambda_invoke_arn = var.get_lambda.invoke_arn
  # ...
}

module "post_custom" {
  source = "../../shared/api_lambda_integration"
  
  api_id            = aws_api_gateway_rest_api.api.id
  resource_id       = aws_api_gateway_resource.custom.id
  http_method       = "POST"
  lambda_invoke_arn = var.post_lambda.invoke_arn
  # ...
}
```

## When to Use Which

| Scenario | Use Module |
|----------|------------|
| Simple endpoint (resource + CORS + Lambda) | `api_gateway_endpoint` |
| Multiple methods on same resource | `api_lambda_integration` (per method) |
| Non-Lambda integration needs CORS | `api_cors_preflight` |
| Custom resource structure | Individual modules |

This follows the Unix philosophy: **Do one thing well, compose for complexity**.
