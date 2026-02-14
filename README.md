# Terraform Modules

Custom Terraform modules for reuse across projects.

## Usage

Reference modules from this repository in your Terraform configurations:

```hcl
module "example" {
  source = "git::https://github.com/<your-username>/terraform-modules.git//modules/<module-name>?ref=v1.0.0"
  
  # Module variables
}
```

Or for local development:

```hcl
module "example" {
  source = "../terraform-modules/modules/<module-name>"
  
  # Module variables
}
```

## Module Structure

Each module follows this structure:

```
modules/<module-name>/
├── main.tf          # Main resources
├── variables.tf     # Input variables
├── outputs.tf       # Output values
├── versions.tf      # Provider version constraints
└── README.md        # Module documentation
```

## Available Modules

- `s3-cloudfront-website` - Static website hosting with S3 and CloudFront
- `terraform-backend` - S3 and DynamoDB backend for Terraform state

## Contributing

When adding new modules:
1. Follow the standard module structure
2. Include comprehensive documentation
3. Use semantic versioning for tags
4. Test modules before committing
