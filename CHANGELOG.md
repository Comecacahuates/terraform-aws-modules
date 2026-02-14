# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
