# Development Workflow

## Git Workflow

**Important:** Only commit or push changes when explicitly requested by the user.

## Commit Conventions

Use [Conventional Commits](https://www.conventionalcommits.org/) format:

```
<type>(<scope>): <description>

[optional body]
```

**Types:**
- `feat:` - New module or feature
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `chore:` - Maintenance tasks
- `refactor:` - Code refactoring
- `test:` - Adding tests

**Examples:**
```bash
git commit -m "feat: add s3-cloudfront-website module"
git commit -m "fix(terraform-backend): correct DynamoDB table name"
git commit -m "docs: update README with usage examples"
```

## Release Process

1. Update CHANGELOG.md with changes
2. Commit changes: `git commit -m "docs: update CHANGELOG for vX.Y.Z"`
3. Create tag: `git tag -a vX.Y.Z -m "chore(release): vX.Y.Z"`
4. Push: `git push origin main && git push origin vX.Y.Z`

## Semantic Versioning

- **Major (v2.0.0)**: Breaking changes (variable renames, removed outputs)
- **Minor (v1.1.0)**: New features, backward compatible
- **Patch (v1.0.1)**: Bug fixes, no new features

## Module Development Workflow

1. Create module files following standard structure
2. Run `terraform fmt` to format code
3. Run `terraform validate` to check syntax
4. Test deployment in sandbox AWS account
5. Update module README with usage examples
6. Update CHANGELOG.md
7. Commit with conventional commit format (when requested)
8. Create version tag for release (when requested)
