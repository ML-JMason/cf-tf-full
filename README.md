# Cloudflare Terraform Monorepo

Production-grade Terraform monorepo for managing many Cloudflare domains from one reusable mega-module.

## Highlights

- Terraform `>= 1.9.0`
- Cloudflare provider `~> 5.0`
- One reusable module (`modules/cloudflare`) for multi-feature domain operations
- Domain-centric tfvars (`domains/<domain>.tfvars`)
- Azure remote state backend with OIDC-first defaults
- AWS S3 backend switch-ready example
- GitHub Actions CI/CD with changed-domain matrix plans/applies
- Security scanning (tfsec, Checkov, Trivy)

## Repository Layout

- `modules/cloudflare`: Reusable Cloudflare module
- `domains/*.tfvars`: Per-domain configuration
- `backends/azure.tfvars`: Azure backend partial config
- `backends/aws.tfvars.example`: S3 backend example values

## Quick Start

1. Configure Cloudflare credentials (recommended: API token) and Azure OIDC credentials for CI.
2. Copy and edit domain file:
   ```bash
   cp domains/example.com.tfvars domains/mydomain.com.tfvars
   ```
3. Initialize and plan locally:
   ```bash
   terraform init -backend-config=backends/azure.tfvars
   terraform plan -var-file=domains/mydomain.com.tfvars
   ```
4. Apply (manual/local):
   ```bash
   terraform apply -var-file=domains/mydomain.com.tfvars
   ```

## Add a New Domain

1. Create `domains/<domain>.tfvars`.
2. Set at least `domain` and `account_id`.
3. Add only the features that domain needs.
4. Open a PR; CI will auto-detect changed domain files and plan only those domains.

## Switch Backend to AWS S3 Later

1. Update `backend.tf` backend block to `s3`.
2. Use values from `backends/aws.tfvars.example`.
3. Re-run `terraform init -migrate-state`.

## Security and Quality

- Pre-commit hooks: fmt, validate, tflint, tfsec
- Security workflow runs tfsec + Checkov + Trivy
- Dependabot updates Actions and Terraform dependencies monthly

## Branch Protection (recommended)

Configure branch protection on `main` with:
- Required status checks: fmt, validate, security, plan
- Require pull request reviews
- Restrict force pushes
- Require linear history (optional)

## CI/CD Notes

- `terraform-plan.yml`: PR plans only changed `domains/*.tfvars`
- `terraform-apply.yml`: Push to `main`, environment-gated for manual approval
- Slack/Teams notification steps are included as placeholders for enterprise chat integrations
