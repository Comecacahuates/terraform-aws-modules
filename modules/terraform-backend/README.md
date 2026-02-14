# Terraform Backend Module

Bootstrap module for creating S3 bucket and DynamoDB table for Terraform remote state backend.

## Features

- S3 bucket with versioning enabled
- Server-side encryption (AES256)
- Public access blocked
- DynamoDB table for state locking
- Pay-per-request billing mode

## Usage

### Step 1: Bootstrap the Backend

```hcl
module "terraform_backend" {
  source = "../../modules/terraform-backend"
  
  bucket_name          = "my-terraform-state"
  dynamodb_table_name  = "terraform-state-lock"
  
  tags = {
    Environment = "shared"
    Purpose     = "terraform-state"
  }
}
```

Run:
```bash
terraform init
terraform apply
```

### Step 2: Configure Backend

After the resources are created, add the backend configuration to your `terraform` block:

```hcl
terraform {
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}
```

Then migrate the state:
```bash
terraform init -migrate-state
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| bucket_name | Name of the S3 bucket for Terraform state | string | n/a | yes |
| dynamodb_table_name | Name of the DynamoDB table for state locking | string | terraform-state-lock | no |
| tags | Tags to apply to resources | map(string) | {} | no |

## Outputs

| Name | Description |
|------|-------------|
| s3_bucket_name | Name of the S3 bucket |
| s3_bucket_arn | ARN of the S3 bucket |
| dynamodb_table_name | Name of the DynamoDB table |
| dynamodb_table_arn | ARN of the DynamoDB table |
| backend_config | Backend configuration block for use in terraform block |

## Notes

- S3 bucket names must be globally unique
- This module should be applied with local state first, then migrate to remote state
- Versioning protects against accidental state file deletion
