variable "domain" {
  description = "Primary domain name for the Cloudflare zone."
  type        = string
}

variable "account_id" {
  description = "Cloudflare account ID used for account-scoped resources."
  type        = string
  default     = null

  validation {
    condition = var.account_id != null || (
      !var.zone_enabled &&
      var.existing_zone_id != null &&
      length(var.worker_scripts) == 0 &&
      length(var.r2_buckets) == 0 &&
      length(var.d1_databases) == 0 &&
      length(var.load_balancer_pools) == 0 &&
      length(var.access_policies) == 0
    )
    error_message = "account_id is required when creating a zone or when using account-scoped resources (workers, R2, D1, load balancer pools, or access policies)."
  }
}

variable "zone_enabled" {
  description = "Create/manage Cloudflare zone for this domain."
  type        = bool
  default     = true
}

variable "zone_type" {
  description = "Cloudflare zone type."
  type        = string
  default     = "full"
}

variable "existing_zone_id" {
  description = "Existing Cloudflare zone ID. Use this when zone_enabled is false but zone-scoped resources should be managed."
  type        = string
  default     = null

  validation {
    condition = var.zone_enabled || var.existing_zone_id != null || (
      length(var.zone_settings) == 0 &&
      length(var.dns_records) == 0 &&
      length(var.rulesets) == 0 &&
      length(var.access_applications) == 0 &&
      length(var.worker_routes) == 0 &&
      length(var.load_balancers) == 0 &&
      length(var.spectrum_applications) == 0
    )
    error_message = "Set existing_zone_id when zone_enabled is false and zone-scoped resources are configured."
  }
}

variable "zone_settings" {
  description = "Zone settings map."
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
  description = "Rulesets for WAF, transform, cache, API shield, rate limiting, bot management, and custom phases."
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
  description = "Zero Trust Access applications keyed by logical name."
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
  description = "Zero Trust Access policies keyed by logical name."
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
  description = "Worker scripts keyed by script name."
  type = map(object({
    content            = string
    module             = optional(bool, false)
    compatibility_date = optional(string)
  }))
  default = {}
}

variable "worker_routes" {
  description = "Worker routes keyed by route name."
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
