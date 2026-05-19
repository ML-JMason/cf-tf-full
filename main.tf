module "cloudflare" {
  source = "./modules/cloudflare"

  domain                = var.domain
  account_id            = var.account_id
  zone_enabled          = var.zone_enabled
  zone_type             = var.zone_type
  zone_plan             = var.zone_plan
  zone_settings         = var.zone_settings
  dns_records           = var.dns_records
  rulesets              = var.rulesets
  access_applications   = var.access_applications
  access_policies       = var.access_policies
  worker_scripts        = var.worker_scripts
  worker_routes         = var.worker_routes
  r2_buckets            = var.r2_buckets
  d1_databases          = var.d1_databases
  load_balancer_pools   = var.load_balancer_pools
  load_balancers        = var.load_balancers
  spectrum_applications = var.spectrum_applications
}
