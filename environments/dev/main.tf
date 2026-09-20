module "resource_groups" {
  source          = "../../modules/resource_group"
  resource_groups = var.infra_config.resource_groups
}

module "acr" {
  source = "../../modules/acr"
  container_registries = {
    for k, v in var.infra_config.container_registries : k => {
      resource_group_name = module.resource_groups.resource_group_names[v.rg_key]
      location            = var.infra_config.resource_groups[v.rg_key].location
      sku                 = v.sku
      admin_enabled       = v.admin_enabled
      tags                = v.tags
    }
  }
}

module "aks" {
  source = "../../modules/aks"
  kubernetes_clusters = {
    for k, v in var.infra_config.kubernetes_clusters : k => {
      resource_group_name = module.resource_groups.resource_group_names[v.rg_key]
      location            = var.infra_config.resource_groups[v.rg_key].location
      dns_prefix          = v.dns_prefix
      default_node_pool   = v.default_node_pool
      tags                = v.tags
    }
  }
}

module "postgresql" {
  source = "../../modules/postgresql_flexible_server"
  postgresql_servers = {
    for k, v in var.infra_config.postgresql_servers : k => {
      resource_group_name           = module.resource_groups.resource_group_names[v.rg_key]
      location                      = var.infra_config.resource_groups[v.rg_key].location
      version                       = v.version
      sku_name                      = v.sku_name
      storage_mb                    = v.storage_mb
      administrator_login           = v.administrator_login
      administrator_password        = v.administrator_password
      backup_retention_days         = v.backup_retention_days
      geo_redundant_backup_enabled  = v.geo_redundant_backup_enabled
      zone                          = v.zone
      public_network_access_enabled = v.public_network_access_enabled
      delegated_subnet_id           = v.delegated_subnet_id
      private_dns_zone_id           = v.private_dns_zone_id
      high_availability             = v.high_availability
      databases                     = v.databases
      firewall_rules                = v.firewall_rules
      tags                          = v.tags
    }
  }
}
