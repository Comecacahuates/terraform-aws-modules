# Project Structure

## Repository Layout

```
terraform-modules/
├── .kiro/
│   ├── agents/              # Custom Kiro agents
│   └── steering/            # Steering documents
├── modules/
│   └── <module-name>/
│       ├── main.tf          # Main resources
│       ├── variables.tf     # Input variables
│       ├── outputs.tf       # Output values
│       ├── versions.tf      # Provider version constraints
│       └── README.md        # Module documentation
├── .gitignore
└── README.md                # Repository documentation
```

## Module Structure Standards

Every module must follow this exact structure:

### main.tf
- Contains all resource definitions
- Resources grouped logically (e.g., S3 resources together, IAM together)
- Use data sources for dynamic lookups
- Include comments for complex logic

### variables.tf
- All input variables with descriptions
- Specify types explicitly
- Provide sensible defaults where appropriate
- Required variables have no default

### outputs.tf
- All output values with descriptions
- Export resource IDs, ARNs, and URLs
- Include computed values useful for downstream modules

### versions.tf
- Terraform version constraint
- Provider version constraints
- Data sources for region/account info if needed

### README.md
- Module description and features
- Usage examples (basic and advanced)
- Input/output tables
- Requirements section
- Deployment instructions

## Naming Conventions

### Module Names
- Use kebab-case: `s3-cloudfront-website`, `terraform-backend`
- Descriptive and service-focused
- Avoid abbreviations unless widely recognized

### Resource Names
- Use snake_case in Terraform: `aws_s3_bucket.website`
- Prefix with service: `website`, `terraform_state`
- Logical and descriptive

### Variables
- Use snake_case: `bucket_name`, `domain_name`
- Descriptive, not abbreviated
- Boolean variables prefixed with `enable_` or similar

### Tags
- Always include `tags` variable (map(string))
- Apply tags to all taggable resources
- Use merge() for combining default and user tags

## File Organization

- One resource type per logical block
- Related resources grouped together
- Data sources at top of main.tf or in versions.tf
- Comments for non-obvious configurations

## Import Patterns

- Use fully qualified resource addresses
- Avoid circular dependencies between modules
- Data sources for cross-module references

## Versioning

- Use semantic versioning: `v1.0.0`
- Tag releases in Git
- Document breaking changes in release notes
- Never modify published versions
