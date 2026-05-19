output "zone_id" {
  description = "Cloudflare zone ID."
  value       = local.effective_zone_id
}

output "zone_name_servers" {
  description = "Zone nameservers assigned by Cloudflare."
  value       = one(concat(cloudflare_zone.this[*].name_servers, [[]]))
}

output "dashboard_urls" {
  description = "Handy Cloudflare dashboard links for this domain."
  value = {
    overview   = local.effective_zone_id == null ? null : "https://dash.cloudflare.com/?to=/:account/${var.account_id}/${var.domain}"
    dns        = local.effective_zone_id == null ? null : "https://dash.cloudflare.com/?to=/:account/${var.domain}/dns"
    waf        = local.effective_zone_id == null ? null : "https://dash.cloudflare.com/?to=/:account/${var.domain}/security/waf"
    workers    = var.account_id == null ? null : "https://dash.cloudflare.com/?to=/:account/workers-and-pages"
    zerotrust  = var.account_id == null ? null : "https://one.dash.cloudflare.com/${var.account_id}"
  }
}

output "managed_resource_counts" {
  description = "Resource counts per feature for visibility and auditing."
  value = {
    dns_records           = length(cloudflare_record.records)
    rulesets              = length(cloudflare_ruleset.zone_rulesets)
    access_applications   = length(cloudflare_access_application.apps)
    access_policies       = length(cloudflare_access_policy.policies)
    worker_scripts        = length(cloudflare_worker_script.scripts)
    worker_routes         = length(cloudflare_worker_route.routes)
    r2_buckets            = length(cloudflare_r2_bucket.buckets)
    d1_databases          = length(cloudflare_d1_database.databases)
    load_balancer_pools   = length(cloudflare_load_balancer_pool.pools)
    load_balancers        = length(cloudflare_load_balancer.lbs)
    spectrum_applications = length(cloudflare_spectrum_application.apps)
  }
}
