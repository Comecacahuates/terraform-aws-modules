# Terraform Module Standards

## Module Design Principles

### Single Responsibility
Each module should do one thing well. Don't combine unrelated resources.

**Good**: `s3-cloudfront-website` - Creates S3 bucket and CloudFront for static hosting
**Bad**: `web-infrastructure` - Creates S3, CloudFront, RDS, EC2, and VPC

### Composability
Modules should work together. Use outputs from one module as inputs to another.

### Minimal Required Variables
Only require variables that have no sensible default. Provide defaults for everything else.

### Secure by Default
- Enable encryption by default
- Block public access by default
- Use least privilege IAM policies
- Enable logging and monitoring

## Variable Standards

### Required Variables
```hcl
variable "name" {
  description = "Name of the resource"
  type        = string
}
```

### Optional Variables with Defaults
```hcl
variable "enable_versioning" {
  description = "Enable versioning on S3 bucket"
  type        = bool
  default     = true
}
```

### Complex Types
```hcl
variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
```

## Output Standards

Always output:
- Resource IDs
- Resource ARNs
- URLs or endpoints
- Any computed values needed by other modules

```hcl
output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.this.arn
}
```

## Security Best Practices

### S3 Buckets
- Always block public access unless explicitly needed
- Enable versioning for state buckets
- Enable encryption (AES256 or KMS)
- Use bucket policies with least privilege

### IAM
- Use IAM policy documents (data sources)
- Implement least privilege access
- Use conditions in policies where appropriate

### CloudFront
- Use Origin Access Control (OAC), not legacy OAI
- Enforce HTTPS (redirect-to-https)
- Use TLS 1.2 minimum

## Documentation Requirements

### Module README Must Include
1. Description and features
2. Basic usage example
3. Advanced usage example (if applicable)
4. Requirements (Terraform version, providers)
5. Input variables table
6. Outputs table
7. Deployment/usage instructions

### Code Comments
- Explain "why", not "what"
- Document non-obvious configurations
- Reference AWS documentation for complex settings

## Testing Approach

Before committing a module:
1. Run `terraform fmt` to format code
2. Run `terraform validate` to check syntax
3. Test deployment in a sandbox AWS account
4. Verify all outputs are correct
5. Test module destruction (cleanup)

## Version Management

### Semantic Versioning
- **Major (v2.0.0)**: Breaking changes (variable renames, removed outputs)
- **Minor (v1.1.0)**: New features, backward compatible
- **Patch (v1.0.1)**: Bug fixes, no new features

### Release Process
1. Update module code
2. Update README with changes
3. Test thoroughly
4. Commit changes
5. Create Git tag: `git tag -a v1.0.0 -m "Release description"`
6. Push tag: `git push origin v1.0.0`

### Breaking Changes
Document in README and release notes:
- What changed
- Why it changed
- Migration path for users

## Anti-Patterns to Avoid

❌ Hardcoded values (regions, account IDs)
❌ Overly complex modules doing too much
❌ Missing descriptions on variables/outputs
❌ No default tags variable
❌ Public S3 buckets without explicit intent
❌ Missing encryption
❌ No versioning on state buckets
❌ Modifying published versions
