# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
