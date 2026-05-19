output "zone_id" {
  description = "Cloudflare zone ID."
  value       = module.cloudflare.zone_id
}

output "zone_name_servers" {
  description = "Cloudflare assigned zone nameservers."
  value       = module.cloudflare.zone_name_servers
}

output "dashboard_urls" {
  description = "Useful Cloudflare dashboard URLs."
  value       = module.cloudflare.dashboard_urls
}
