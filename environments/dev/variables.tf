variable "infra_config" {
  description = "Complete infrastructure configuration for Dev environment"
  type = object({
    resource_groups = map(object({
      location = string
      tags     = optional(map(string), {})
    }))
    container_registries = map(object({
      rg_key        = string
      sku           = optional(string, "Standard")
      admin_enabled = optional(bool, false)
      tags          = optional(map(string), {})
    }))
    kubernetes_clusters = map(object({
      rg_key     = string
      dns_prefix = string
      default_node_pool = object({
        name       = string
        node_count = optional(number, 1)
        vm_size    = optional(string, "Standard_DS2_v2")
      })
      tags = optional(map(string), {})
    }))
    postgresql_servers = optional(map(object({
      rg_key                        = string
      version                       = optional(string, "15")
      sku_name                      = optional(string, "B_Standard_B1ms")
      storage_mb                    = optional(number, 32768)
      administrator_login           = optional(string, "psqladmin")
      administrator_password        = optional(string)
      backup_retention_days         = optional(number, 7)
      geo_redundant_backup_enabled  = optional(bool, false)
      zone                          = optional(string)
      public_network_access_enabled = optional(bool, true)
      delegated_subnet_id           = optional(string)
      private_dns_zone_id           = optional(string)
      tags                          = optional(map(string), {})
      high_availability = optional(object({
        mode                      = string
        standby_availability_zone = optional(string)
      }))
      databases = optional(map(object({
        collation = optional(string, "en_US.utf8")
        charset   = optional(string, "UTF8")
      })), {})
      firewall_rules = optional(map(object({
        start_ip_address = string
        end_ip_address   = string
      })), {})
    })), {})
  })
}
