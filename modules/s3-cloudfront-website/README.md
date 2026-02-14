# S3 CloudFront Website Module

Deploys a static website using S3 and CloudFront with Origin Access Control (OAC).

## Features

- S3 bucket with private access
- CloudFront distribution with HTTPS
- Origin Access Control for secure S3 access
- Optional custom domain support
- Automatic HTTPS redirect

## Usage

### Basic Usage

```hcl
module "website" {
  source = "../../modules/s3-cloudfront-website"
  
  bucket_name = "my-website-bucket"
  
  tags = {
    Environment = "production"
    Project     = "my-website"
  }
}
```

### With Custom Domain

```hcl
module "website" {
  source = "../../modules/s3-cloudfront-website"
  
  bucket_name          = "my-website-bucket"
  domain_name          = "www.example.com"
  acm_certificate_arn  = "arn:aws:acm:us-east-1:123456789012:certificate/..."
  
  tags = {
    Environment = "production"
  }
}
```

## Requirements

- Terraform >= 1.0
- AWS Provider >= 5.0
- ACM certificate must be in us-east-1 region for CloudFront

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| bucket_name | Name of the S3 bucket | string | n/a | yes |
| domain_name | Custom domain name | string | null | no |
| acm_certificate_arn | ARN of ACM certificate for custom domain | string | null | no |
| price_class | CloudFront price class | string | PriceClass_100 | no |
| default_root_object | Default root object | string | index.html | no |
| tags | Tags to apply to resources | map(string) | {} | no |

## Outputs

| Name | Description |
|------|-------------|
| bucket_name | Name of the S3 bucket |
| bucket_arn | ARN of the S3 bucket |
| cloudfront_distribution_id | ID of the CloudFront distribution |
| cloudfront_domain_name | Domain name of the CloudFront distribution |
| cloudfront_arn | ARN of the CloudFront distribution |
| website_url | URL of the website |

## Deploying Content

Upload your website files to the S3 bucket:

```bash
aws s3 sync ./website-files s3://my-website-bucket/
```

Invalidate CloudFront cache after updates:

```bash
aws cloudfront create-invalidation --distribution-id <distribution-id> --paths "/*"
```
