locals {
  effective_zone_id = one(concat(cloudflare_zone.this[*].id, [null]))
}

resource "cloudflare_zone" "this" {
  count = var.zone_enabled ? 1 : 0

  account = {
    id = var.account_id
  }
  name = var.domain
  type = var.zone_type
  plan = var.zone_plan
}

resource "cloudflare_zone_setting" "settings" {
  for_each = local.effective_zone_id == null ? {} : var.zone_settings

  zone_id    = local.effective_zone_id
  setting_id = each.key
  value      = tostring(each.value)
}

resource "cloudflare_record" "records" {
  for_each = local.effective_zone_id == null ? {} : var.dns_records

  zone_id  = local.effective_zone_id
  name     = each.value.name
  type     = each.value.type
  value    = try(each.value.value, null)
  ttl      = each.value.ttl
  proxied  = each.value.proxied
  priority = try(each.value.priority, null)
  comment  = try(each.value.comment, null)
  tags     = try(each.value.tags, [])
  data     = try(each.value.data, {})
}

resource "cloudflare_ruleset" "zone_rulesets" {
  for_each = local.effective_zone_id == null ? {} : {
    for rs in var.rulesets : "${rs.phase}-${rs.name}" => rs
  }

  zone_id     = local.effective_zone_id
  name        = each.value.name
  description = try(each.value.description, null)
  kind        = each.value.kind
  phase       = each.value.phase

  dynamic "rules" {
    for_each = try(each.value.rules, [])
    content {
      action      = rules.value.action
      expression  = rules.value.expression
      description = try(rules.value.description, null)
      enabled     = try(rules.value.enabled, true)

      dynamic "action_parameters" {
        for_each = length(try(rules.value.action_parameters, {})) == 0 ? [] : [rules.value.action_parameters]
        content {
          id = try(action_parameters.value.id, null)
        }
      }

      dynamic "logging" {
        for_each = try(rules.value.logging.enabled, false) ? [1] : []
        content {
          enabled = true
        }
      }
    }
  }
}

resource "cloudflare_access_application" "apps" {
  for_each = local.effective_zone_id == null ? {} : var.access_applications

  zone_id                     = local.effective_zone_id
  name                        = each.value.name
  domain                      = each.value.domain
  type                        = each.value.type
  session_duration            = each.value.session_duration
  auto_redirect_to_identity   = each.value.auto_redirect_to_identity
  allowed_idps                = each.value.allowed_idps
}

resource "cloudflare_access_policy" "policies" {
  for_each = local.effective_zone_id == null ? {} : var.access_policies

  zone_id         = local.effective_zone_id
  application_id  = cloudflare_access_application.apps[each.value.application_key].id
  name            = each.value.name
  precedence      = each.value.precedence
  decision        = each.value.decision
  include         = try(each.value.include, [])
  exclude         = try(each.value.exclude, [])
  require         = try(each.value.require, [])
}

resource "cloudflare_worker_script" "scripts" {
  for_each = var.worker_scripts

  account_id         = var.account_id
  name               = each.key
  content            = each.value.content
  module             = each.value.module
  compatibility_date = try(each.value.compatibility_date, null)
}

resource "cloudflare_worker_route" "routes" {
  for_each = local.effective_zone_id == null ? {} : var.worker_routes

  zone_id     = local.effective_zone_id
  pattern     = each.value.pattern
  script_name = each.value.script_name
}

resource "cloudflare_r2_bucket" "buckets" {
  for_each = var.r2_buckets

  account_id = var.account_id
  name       = each.value.name
  location   = each.value.location
}

resource "cloudflare_d1_database" "databases" {
  for_each = var.d1_databases

  account_id            = var.account_id
  name                  = each.value.name
  primary_location_hint = each.value.primary_location_hint
}

resource "cloudflare_load_balancer_pool" "pools" {
  for_each = var.load_balancer_pools

  account_id       = var.account_id
  name             = each.value.name
  minimum_origins  = each.value.minimum_origins

  dynamic "origins" {
    for_each = each.value.origins
    content {
      name    = origins.value.name
      address = origins.value.address
      enabled = origins.value.enabled
      weight  = origins.value.weight
    }
  }
}

resource "cloudflare_load_balancer" "lbs" {
  for_each = local.effective_zone_id == null ? {} : var.load_balancers

  zone_id          = local.effective_zone_id
  name             = each.value.name
  fallback_pool_id = cloudflare_load_balancer_pool.pools[each.value.fallback_pool].id
  default_pool_ids = [for p in each.value.default_pools : cloudflare_load_balancer_pool.pools[p].id]
  proxied          = each.value.proxied
  steering_policy  = each.value.steering_policy
  ttl              = each.value.ttl
}

resource "cloudflare_spectrum_application" "apps" {
  for_each = local.effective_zone_id == null ? {} : var.spectrum_applications

  zone_id          = local.effective_zone_id
  protocol         = each.value.protocol
  dns {
    type = "CNAME"
    name = each.value.dns_name
  }
  origin_direct    = each.value.origin_direct
  ip_firewall      = each.value.ip_firewall
  proxy_protocol   = each.value.proxy_protocol
}
