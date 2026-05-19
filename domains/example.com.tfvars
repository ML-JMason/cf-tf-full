# Domain-scoped configuration template.
# Keep this file minimal and override only what this domain needs.

domain     = "example.com"
account_id = "00000000000000000000000000000000"

dns_records = {
  apex_a = {
    name    = "@"
    type    = "A"
    value   = "203.0.113.10"
    proxied = true
  }
}

rulesets = []
