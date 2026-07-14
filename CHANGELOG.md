# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.4.0] - 2026-07-14

### Added
- Event handler pattern module
  - `patterns/event-handler` - Complete EventBridge → Lambda → DLQ → CloudWatch alarm pattern
  - Creates Lambda function (Go, provided.al2023, x86_64) with IAM role and policy
  - Creates EventBridge rule + target with Lambda permission
  - Optional dead-letter queue with configurable retries and max event age
  - Optional CloudWatch alarm on DLQ messages → SNS notification
  - Single module call replaces lambda/go + eventbridge/lambda-trigger + manual DLQ setup

## [2.3.0] - 2026-03-01

### Added
- Usage plan with rate limiting and quotas in rest-api module
  - Always enabled with sensible defaults (10k req/month, 50 req/s, 100 burst)
  - Optional API key creation via `api_key_name` variable
  - Outputs: `usage_plan_id`, `api_key_id`, `api_key_value`

## [2.2.0] - 2026-03-01

### Added
- API key support in method-handler
  - New `api_key_required` variable (default: false)

## [2.1.0] - 2026-03-01

### Changed
- API Gateway method-handler now creates request validator internally
  - Removed `request_validator_id` variable
  - Validator automatically created when `request_model_schema` is provided
  - Simpler API - no manual validator creation needed

### Removed
- `request_validator_id` variable from method-handler (validator created automatically)
- `request_model_name` variable from method-handler (use `request_model_schema` instead)

## [2.0.0] - 2026-03-01

### Added
- API Gateway rest-resource module
  - `api-gateway/rest-resource` - Resource with optional CORS preflight
  - Fixes CORS conflicts when multiple methods target same resource
- API Gateway method-handler module
  - `api-gateway/method-handler` - HTTP method + Lambda integration + validation
  - Absorbs functionality from deprecated lambda-integration module

### Changed
- **BREAKING**: API Gateway module structure refactored
  - Use `rest-resource` + `method-handler` instead of `rest-endpoint`
  - One CORS configuration per resource, multiple methods per resource

### Removed
- **BREAKING**: Deprecated API Gateway modules removed
  - `api-gateway/rest-endpoint` - Use `rest-resource` + `method-handler`
  - `api-gateway/lambda-integration` - Merged into `method-handler`
  - `api-gateway/cors-preflight` - Merged into `rest-resource`
  - `api-gateway/endpoint` - Old module removed

## [1.5.0] - 2026-03-01

### Added
- EventBridge Lambda trigger module
  - `eventbridge/lambda-trigger` - EventBridge rule + target + Lambda permission
- DynamoDB single-table module
  - `dynamodb/single-table` - Opinionated single-table design with PK/SK and optional GSI1
  - Environment-aware point-in-time recovery
  - Configurable prevent_destroy lifecycle
- API Gateway REST API module
  - `api-gateway/rest-api` - Base REST API with deployment, stage, and logging
  - Environment-aware log retention
- API Gateway REST endpoint module
  - `api-gateway/rest-endpoint` - Complete REST endpoint (resource + CORS + Lambda integration)
  - Renamed from `endpoint` for clarity
- API Gateway validation schema support
  - Lambda modules now output `api_gateway_validation_schema`
  - REST endpoint module creates validation model when schema provided
- API Gateway overview README with DDD/bounded context pattern examples

### Changed
- Lambda Go module defaults reduced for minimal resource usage
  - `timeout` default: 10s → 3s
  - `memory_size` default: 256MB → 128MB
- DynamoDB GSI now uses `key_schema` instead of deprecated `hash_key`/`range_key`

### Deprecated
- `api-gateway/endpoint` module (use `api-gateway/rest-endpoint` instead)

## [1.4.0] - 2026-02-14

### Added
- SNS email topic module
  - `sns/email-topic` - SNS topic with email subscriptions
  - Support for multiple email addresses
  - Email confirmation required by subscribers

## [1.3.1] - 2026-02-14

### Fixed
- lambda/go module main.tf file

## [1.3.0] - 2026-02-14

### Added
- Lambda modules for serverless functions
  - `lambda/standard` - Generic Lambda module for any runtime
  - `lambda/go` - Go-specific Lambda module with optimized defaults
- Support for reserved concurrent executions
- Support for architectures (x86_64 or arm64)
- Optional environment variables block (only created when needed)
- Go module defaults to arm64 (Graviton2) for better price/performance

### Changed
- IAM role naming: `{function_name}-role` to avoid conflicts

## [1.2.0] - 2026-02-14

### Added
- API Gateway modules for Lambda integration
  - `api-gateway/cors-preflight` - CORS OPTIONS method configuration
  - `api-gateway/lambda-integration` - Lambda integration with AWS type
  - `api-gateway/endpoint` - Composite module combining resource, CORS, and Lambda
- CORS fully configured in infrastructure code (not in Lambda)
- Support for authorization, request validation, and custom CORS origins

## [1.1.0] - 2026-02-14

### Changed
- Moved s3-cloudfront-website module to root directory
- Removed modules/ folder structure for simpler repository layout

### Removed
- terraform-backend module (moved to separate repository)

## [1.0.0] - 2026-02-14

### Added
- Initial release of terraform-aws-modules
- `s3-cloudfront-website` module for static website hosting
  - S3 bucket with private access
  - CloudFront distribution with Origin Access Control (OAC)
  - Optional custom domain support with ACM
  - HTTPS redirect enabled by default
- `terraform-backend` module for Terraform state management
  - S3 bucket with versioning and encryption
  - DynamoDB table for state locking
  - Pay-per-request billing mode
  - Public access blocked by default
