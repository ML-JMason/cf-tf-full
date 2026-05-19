# Architecture

## Design Goals

- Single reusable module for Cloudflare domain operations.
- Minimal per-domain configuration via tiny tfvars files.
- Scalable for current domains and future growth.
- Secure-by-default CI/CD with OIDC and automated checks.

## Why a Monorepo

- Shared standards, providers, and automation.
- Centralized governance and security controls.
- Lower operational overhead versus duplicated per-domain stacks.

## Terraform Structure

- Root module delegates everything to `modules/cloudflare`.
- Root variables mirror module inputs so each run can be driven by one tfvars file.
- Module uses `for_each` and dynamic blocks for high fan-out resources (records/rules/policies/routes).

## State and Environments

- Azure backend (`azurerm`) is default with OIDC options in `backends/azure.tfvars`.
- AWS S3 migration path is documented and pre-seeded in `backends/aws.tfvars.example`.

## CI/CD Strategy

- PR pipeline enforces formatting, validation, and security scans.
- Plan job detects changed domain tfvars and only plans impacted domains.
- Apply job runs on `main` and should be protected by GitHub Environment approvals.

## Extensibility

The module includes broad Cloudflare coverage (zone, DNS, rulesets, Zero Trust Access, Workers, R2, D1, load balancing, Spectrum), and can be extended with additional resources while preserving the same per-domain tfvars pattern.
