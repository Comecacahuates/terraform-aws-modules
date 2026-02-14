# Technology Stack

## Infrastructure as Code

- **Terraform**: >= 1.0
- **AWS Provider**: >= 6.0
- **Version Control**: Git with semantic versioning tags

## AWS Services

Primary services used across modules:

- **S3**: Object storage, static website hosting, Terraform state
- **CloudFront**: CDN and content delivery
- **DynamoDB**: State locking for Terraform
- **IAM**: Access control and policies
- **ACM**: SSL/TLS certificates

## Development Tools

- **Git**: Version control and module distribution
- **AWS CLI**: Testing and validation
- **Terraform CLI**: Module development and testing

## Technical Constraints

- All modules must support AWS Provider >= 6.0
- Modules must be cloud-agnostic where possible (avoid hardcoded regions)
- Security best practices are mandatory (encryption, private access, least privilege)
- All resources must support tagging for cost allocation
