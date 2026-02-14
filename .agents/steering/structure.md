# Project Structure

## Repository Layout

```
terraform-modules/
├── .agents/
│   ├── skills/              # Kiro skills
│   └── steering/            # Steering documents
├── .kiro/
│   └── agents/              # Custom Kiro agents
├── modules/
│   └── <module-name>/
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       ├── versions.tf
│       └── README.md
├── .gitignore
└── README.md
```

## Module Organization

- All modules in `modules/` directory
- One module per subdirectory
- Module names use kebab-case: `s3-cloudfront-website`, `terraform-backend`

## Versioning Strategy

- Use Git tags with semantic versioning: `v1.0.0`
- Never modify or delete published tags
- Reference modules with version tags in production
