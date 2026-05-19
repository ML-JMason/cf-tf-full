# Cloudflare Mega-Module

Reusable Terraform module for managing enterprise Cloudflare domains with one module call per domain.

## Features

- Zone lifecycle and zone settings
- DNS records (`cloudflare_dns_record`)
- Rulesets for WAF/managed WAF, transform, cache, API shield, bot, rate limiting phases (`cloudflare_ruleset`)
- Zero Trust Access applications and policies (`cloudflare_zero_trust_access_application`, `cloudflare_zero_trust_access_policy`)
- Workers scripts and routes (`cloudflare_workers_script`, `cloudflare_workers_route`)
- Data services (`cloudflare_r2_bucket`, `cloudflare_d1_database`)
- Traffic steering (`cloudflare_load_balancer_pool`, `cloudflare_load_balancer`)
- Spectrum TCP/UDP publishing (`cloudflare_spectrum_application`)

## Usage

```hcl
module "cloudflare" {
  source = "../../cloudflare"

  domain     = "example.com"
  account_id = "00000000000000000000000000000000"

  dns_records = {
    www = {
      name    = "www"
      type    = "CNAME"
      value   = "example.com"
      proxied = true
    }
  }
}
```

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `domain` | Primary domain name for the Cloudflare zone | `string` | n/a |
| `account_id` | Cloudflare account ID for account-level services | `string` | `null` |
| `dns_records` | DNS records keyed by logical name | `map(object(...))` | `{}` |
| `rulesets` | Rulesets for WAF, transform, cache, API shield, and bot/rate phases | `list(object(...))` | `[]` |
| `access_applications` | Access apps keyed by logical name | `map(object(...))` | `{}` |
| `access_policies` | Access policies keyed by logical name | `map(object(...))` | `{}` |
| `worker_scripts` | Worker scripts keyed by script name | `map(object(...))` | `{}` |
| `worker_routes` | Worker routes keyed by route name | `map(object(...))` | `{}` |
| `r2_buckets` | R2 buckets keyed by logical name | `map(object(...))` | `{}` |
| `d1_databases` | D1 databases keyed by logical name | `map(object(...))` | `{}` |
| `load_balancer_pools` | Load balancer pools keyed by logical name | `map(object(...))` | `{}` |
| `load_balancers` | Load balancers keyed by logical name | `map(object(...))` | `{}` |
| `spectrum_applications` | Spectrum applications keyed by logical name | `map(object(...))` | `{}` |

## Outputs

| Name | Description |
|------|-------------|
| `zone_id` | Cloudflare zone ID |
| `zone_name_servers` | Assigned zone nameservers |
| `dashboard_urls` | Useful dashboard links |
| `managed_resource_counts` | Resource counts by feature |
