# API Gateway Modules

Reusable Terraform modules for AWS API Gateway following DDD/bounded context patterns.

## Modules

- **rest-api** - Base REST API with deployment, stage, and logging
- **rest-endpoint** - API Gateway resource + CORS + Lambda integration
- **lambda-integration** - Lambda integration for existing resources
- **cors-preflight** - CORS preflight (OPTIONS) for existing resources

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
  source = "git::https://github.com/Comecacahuates/terraform-modules.git//api-gateway/rest-api?ref=v1.5.0"

  api_name    = "app-${var.environment}-public-api"
  environment = var.environment

  deployment_triggers = {
    leads_create = var.lambda_api_create_lead.invoke_arn
  }

  tags = var.tags
}

resource "aws_api_gateway_request_validator" "body" {
  rest_api_id           = module.public_api.api_id
  name                  = "validate-body"
  validate_request_body = true
}

# POST /leads (with validation)
module "create_lead_endpoint" {
  source = "git::https://github.com/Comecacahuates/terraform-modules.git//api-gateway/rest-endpoint?ref=v1.5.0"

  api_id            = module.public_api.api_id
  parent_id         = module.public_api.root_resource_id
  path_part         = "leads"
  http_method       = "POST"
  api_execution_arn = module.public_api.execution_arn

  lambda_invoke_arn    = var.lambda_api_create_lead.invoke_arn
  lambda_function_name = var.lambda_api_create_lead.function_name

  request_validator_id = aws_api_gateway_request_validator.body.id
  request_model_schema = var.lambda_api_create_lead.validation_schema

  cors_origin = var.cors_allowed_origin
}

# GET /leads (no validation)
module "list_leads_endpoint" {
  source = "git::https://github.com/Comecacahuates/terraform-modules.git//api-gateway/rest-endpoint?ref=v1.5.0"

  api_id            = module.public_api.api_id
  parent_id         = module.public_api.root_resource_id
  path_part         = "leads"
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
- **Concise**: ~30 lines per Lambda handler, ~15 lines per endpoint
- **Flexible**: Validation is optional, just omit when not needed
- **DDD-aligned**: Bounded contexts are self-contained

## Module Details

See individual module READMEs for detailed documentation:
- [rest-api/README.md](./rest-api/README.md)
- [rest-endpoint/README.md](./rest-endpoint/README.md)
- [lambda-integration/README.md](./lambda-integration/README.md)
- [cors-preflight/README.md](./cors-preflight/README.md)
