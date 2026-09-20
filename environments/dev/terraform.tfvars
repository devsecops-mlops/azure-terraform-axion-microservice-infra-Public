infra_config = {
  resource_groups = {
    "rg-micro-prod" = {
      location = "East US"
      tags     = { Environment = "Dev", ManagedBy = "Terraform" }
    }
  }
  container_registries = {
    "acrmicrodev5577" = {
      rg_key = "rg-micro-prod"
      sku    = "Basic"
    }
  }
  kubernetes_clusters = {
    "aks-micro-dev" = {
      rg_key     = "rg-micro-prod"
      dns_prefix = "aksmicrodev"
      default_node_pool = {
        name       = "default"
        node_count = 2
        vm_size    = "Standard_B2s"
      }
    }
  }
  postgresql_servers = {
    "psql-axion-dev-5577" = {
      rg_key              = "rg-micro-prod"
      sku_name            = "B_Standard_B1ms"
      storage_mb          = 32768
      version             = "15"
      administrator_login = "psqladmin"
      databases = {
        "axiondb" = {
          collation = "en_US.utf8"
          charset   = "UTF8"
        }
      }
      firewall_rules = {
        "allow-azure-services" = {
          start_ip_address = "0.0.0.0"
          end_ip_address   = "0.0.0.0"
        }
      }
      tags = { Environment = "Dev", ManagedBy = "Terraform", Tier = "Burstable-POC" }
    }
  }
}
