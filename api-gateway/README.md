# API Gateway Modules

Reusable Terraform modules for AWS API Gateway following DDD/bounded context patterns.

## Modules

- **rest-api** - Base REST API with deployment, stage, and logging
- **rest-resource** - API Gateway resource with optional CORS preflight
- **method-handler** - HTTP method + Lambda integration + validation

## Usage Pattern

### Bounded Context (Business Logic)

Define Lambda handlers with validation schemas:

```hcl
# modules/bounded_contexts/leads/application/lambda_api_create_lead.tf
module "create_lead_lambda" {
  source = "git::https://github.com/Comecacahuates/terraform-modules.git//lambda/go?ref=v1.5.0"

  function_name = "app-${var.environment}-leads-create"
  source_file   = "${var.lambda_packages_dir}/leads_create.zip"

  environment_variables = {
    TABLE_NAME = var.dynamodb_table.name
  }

  policy_statements = [
    {
      Action   = ["dynamodb:PutItem"]
      Resource = [var.dynamodb_table.arn]
    }
  ]

  api_gateway_validation_schema = jsonencode({
    type     = "object"
    required = ["name", "email"]
    properties = {
      name  = { type = "string", minLength = 1 }
      email = { type = "string", pattern = "^[^@]+@[^@]+\\.[^@]+$" }
    }
  })

  tags = var.tags
}

# modules/bounded_contexts/leads/application/outputs.tf
output "lambda_api_create_lead" {
  value = {
    function_name     = module.create_lead_lambda.function_name
    invoke_arn        = module.create_lead_lambda.invoke_arn
    validation_schema = module.create_lead_lambda.api_gateway_validation_schema
  }
}
```

### API Module (Infrastructure)

Wire Lambda handlers to API Gateway:

```hcl
# modules/apis/public/main.tf
module "public_api" {
  source = "git::https://github.com/Comecacahuates/terraform-modules.git//api-gateway/rest-api?ref=v2.0.0"

  api_name    = "app-${var.environment}-public-api"
  environment = var.environment

  deployment_triggers = {
    leads_create = var.lambda_api_create_lead.invoke_arn
    leads_list   = var.lambda_api_list_leads.invoke_arn
  }

  tags = var.tags
}

resource "aws_api_gateway_request_validator" "body" {
  rest_api_id           = module.public_api.api_id
  name                  = "validate-body"
  validate_request_body = true
}

# Create /leads resource with CORS
module "leads_resource" {
  source = "git::https://github.com/Comecacahuates/terraform-modules.git//api-gateway/rest-resource?ref=v2.0.0"

  api_id    = module.public_api.api_id
  parent_id = module.public_api.root_resource_id
  path_part = "leads"

  cors_enabled = true
  cors_methods = "GET,POST,OPTIONS"
  cors_origin  = var.cors_allowed_origin
}

# POST /leads (with validation)
module "create_lead_method" {
  source = "git::https://github.com/Comecacahuates/terraform-modules.git//api-gateway/method-handler?ref=v2.0.0"

  api_id            = module.public_api.api_id
  resource_id       = module.leads_resource.resource_id
  http_method       = "POST"
  api_execution_arn = module.public_api.execution_arn

  lambda_invoke_arn    = var.lambda_api_create_lead.invoke_arn
  lambda_function_name = var.lambda_api_create_lead.function_name

  request_validator_id = aws_api_gateway_request_validator.body.id
  request_model_schema = var.lambda_api_create_lead.validation_schema

  cors_origin = var.cors_allowed_origin
}

# GET /leads (no validation)
module "list_leads_method" {
  source = "git::https://github.com/Comecacahuates/terraform-modules.git//api-gateway/method-handler?ref=v2.0.0"

  api_id            = module.public_api.api_id
  resource_id       = module.leads_resource.resource_id
  http_method       = "GET"
  api_execution_arn = module.public_api.execution_arn

  lambda_invoke_arn    = var.lambda_api_list_leads.invoke_arn
  lambda_function_name = var.lambda_api_list_leads.function_name

  cors_origin = var.cors_allowed_origin
}
```

## Benefits

- **Clean separation**: Business logic in bounded contexts, infrastructure in API modules
- **Type-safe**: Validation schemas flow from Lambda to API Gateway
- **Correct CORS**: One CORS configuration per resource, multiple methods per resource
- **Concise**: ~30 lines per Lambda handler, ~15 lines per resource, ~10 lines per method
- **Flexible**: Validation and CORS are optional
- **DDD-aligned**: Bounded contexts are self-contained

## Module Details

See individual module READMEs for detailed documentation:
- [rest-api/README.md](./rest-api/README.md)
- [rest-resource/README.md](./rest-resource/README.md)
- [method-handler/README.md](./method-handler/README.md)
