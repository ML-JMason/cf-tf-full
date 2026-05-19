terraform {
  required_version = ">= 1.9.0"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.0"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

variable "cloudflare_api_token" {
  type      = string
  sensitive = true
}

module "cloudflare" {
  source = "../.."

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

  rulesets = [
    {
      name  = "managed-waf"
      kind  = "zone"
      phase = "http_request_firewall_managed"
      rules = [
        {
          action     = "execute"
          expression = "true"
          action_parameters = {
            id = "efb7b8c949ac4650a09736fc376e9aee"
          }
        }
      ]
    }
  ]
}
