# Terraform Module Standards

## Project-Specific Requirements

### AWS-Specific Patterns

**S3 Buckets**
- Always use Origin Access Control (OAC) for CloudFront, not legacy OAI
- Block public access by default
- Enable versioning for state buckets

**CloudFront**
- Default to `redirect-to-https` viewer protocol policy
- Use TLS 1.2 minimum for custom domains
- Default price class: `PriceClass_100`

**DynamoDB for State Locking**
- Use `PAY_PER_REQUEST` billing mode
- Hash key must be `LockID` (type: String)

### Module Composition Patterns

Modules should output values needed by other modules:

```hcl
# VPC-like modules output IDs for networking
output "vpc_id" { ... }
output "subnet_ids" { ... }

# Security modules output ARNs
output "role_arn" { ... }
output "policy_arn" { ... }

# Service modules output endpoints
output "website_url" { ... }
output "api_endpoint" { ... }
```

### Version Management

**Release Process:**
1. Test in sandbox AWS account
2. Update module README
3. Commit changes
4. Create Git tag: `git tag -a v1.0.0 -m "Description"`
5. Push tag: `git push origin v1.0.0`

**Breaking Changes:**
Document migration path in README when:
- Renaming variables
- Removing outputs
- Changing resource names (forces replacement)
- Changing default values that affect existing resources
