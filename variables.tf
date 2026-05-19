variable "domain" {
  description = "Primary zone/domain to manage in Cloudflare."
  type        = string
}

variable "account_id" {
  description = "Cloudflare account ID for account-scoped resources."
  type        = string
  default     = null
}

variable "zone_enabled" {
  description = "Whether to create/manage the Cloudflare zone."
  type        = bool
  default     = true
}

variable "zone_type" {
  description = "Cloudflare zone type."
  type        = string
  default     = "full"
}

variable "existing_zone_id" {
  description = "Existing Cloudflare zone ID (used when zone_enabled is false)."
  type        = string
  default     = null
}

variable "zone_settings" {
  description = "Zone-level settings map."
  type        = map(any)
  default     = {}
}

variable "dns_records" {
  description = "DNS records keyed by logical name."
  type = map(object({
    name     = string
    type     = string
    value    = optional(string)
    ttl      = optional(number, 1)
    proxied  = optional(bool, false)
    priority = optional(number)
    comment  = optional(string)
    tags     = optional(list(string), [])
    data     = optional(map(string), {})
  }))
  default = {}
}

variable "rulesets" {
  description = "Cloudflare rulesets to manage (WAF, transform, cache, API shield, etc.)."
  type = list(object({
    name        = string
    kind        = string
    phase       = string
    description = optional(string)
    rules = optional(list(object({
      action            = string
      expression        = string
      description       = optional(string)
      enabled           = optional(bool, true)
      action_parameters = optional(map(any), {})
      logging = optional(object({
        enabled = optional(bool, false)
      }), {})
    })), [])
  }))
  default = []
}

variable "access_applications" {
  description = "Cloudflare Access applications keyed by name."
  type = map(object({
    name                      = string
    domain                    = string
    type                      = optional(string, "self_hosted")
    session_duration          = optional(string, "24h")
    auto_redirect_to_identity = optional(bool, false)
    allowed_idps              = optional(list(string), [])
  }))
  default = {}
}

variable "access_policies" {
  description = "Cloudflare Access policies keyed by name."
  type = map(object({
    application_key = string
    name            = string
    decision        = string
    precedence      = optional(number)
    include         = optional(list(map(list(string))), [])
    exclude         = optional(list(map(list(string))), [])
    require         = optional(list(map(list(string))), [])
  }))
  default = {}
}

variable "worker_scripts" {
  description = "Cloudflare Worker scripts keyed by script name."
  type = map(object({
    content            = string
    module             = optional(bool, false)
    compatibility_date = optional(string)
  }))
  default = {}
}

variable "worker_routes" {
  description = "Cloudflare Worker routes keyed by route name."
  type = map(object({
    pattern     = string
    script_name = string
  }))
  default = {}
}

variable "r2_buckets" {
  description = "R2 buckets keyed by logical name."
  type = map(object({
    name     = string
    location = optional(string, "WEUR")
  }))
  default = {}
}

variable "d1_databases" {
  description = "D1 databases keyed by logical name."
  type = map(object({
    name                  = string
    primary_location_hint = optional(string, "weur")
  }))
  default = {}
}

variable "load_balancer_pools" {
  description = "Load balancer pools keyed by logical name."
  type = map(object({
    name = string
    origins = list(object({
      name    = string
      address = string
      enabled = optional(bool, true)
      weight  = optional(number, 1)
    }))
    minimum_origins = optional(number, 1)
  }))
  default = {}
}

variable "load_balancers" {
  description = "Load balancers keyed by logical name."
  type = map(object({
    name            = string
    fallback_pool   = string
    default_pools   = list(string)
    proxied         = optional(bool, true)
    steering_policy = optional(string, "off")
    ttl             = optional(number, 30)
  }))
  default = {}
}

variable "spectrum_applications" {
  description = "Spectrum applications keyed by logical name."
  type = map(object({
    protocol       = string
    dns_name       = string
    origin_direct  = string
    ip_firewall    = optional(bool, true)
    proxy_protocol = optional(string, "off")
  }))
  default = {}
}
