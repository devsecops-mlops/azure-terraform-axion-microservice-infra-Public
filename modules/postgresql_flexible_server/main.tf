resource "random_password" "admin_password" {
  for_each = {
    for k, v in var.postgresql_servers : k => v
    if v.administrator_password == null || v.administrator_password == ""
  }

  length           = 24
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "azurerm_postgresql_flexible_server" "server" {
  for_each = var.postgresql_servers

  name                   = each.key
  resource_group_name    = each.value.resource_group_name
  location               = each.value.location
  version                = each.value.version
  sku_name               = each.value.sku_name
  storage_mb             = each.value.storage_mb
  administrator_login    = each.value.administrator_login
  administrator_password = coalesce(each.value.administrator_password, try(random_password.admin_password[each.key].result, null))

  backup_retention_days         = each.value.backup_retention_days
  geo_redundant_backup_enabled  = each.value.geo_redundant_backup_enabled
  zone                          = each.value.zone
  public_network_access_enabled = each.value.delegated_subnet_id != null ? false : each.value.public_network_access_enabled

  delegated_subnet_id = each.value.delegated_subnet_id
  private_dns_zone_id = each.value.private_dns_zone_id

  tags = each.value.tags

  dynamic "high_availability" {
    for_each = each.value.high_availability != null ? [each.value.high_availability] : []
    content {
      mode                      = high_availability.value.mode
      standby_availability_zone = high_availability.value.standby_availability_zone
    }
  }

  lifecycle {
    ignore_changes = [
      zone,
      high_availability[0].standby_availability_zone,
    ]
  }
}

locals {
  databases = {
    for item in flatten([
      for server_key, server in var.postgresql_servers : [
        for db_key, db in(server.databases != null ? server.databases : {}) : {
          key        = "${server_key}/${db_key}"
          server_key = server_key
          name       = db_key
          collation  = db.collation != null ? db.collation : "en_US.utf8"
          charset    = db.charset != null ? db.charset : "UTF8"
        }
      ]
    ]) : item.key => item
  }

  firewall_rules = {
    for item in flatten([
      for server_key, server in var.postgresql_servers : [
        for rule_key, rule in(server.firewall_rules != null ? server.firewall_rules : {}) : {
          key              = "${server_key}/${rule_key}"
          server_key       = server_key
          name             = rule_key
          start_ip_address = rule.start_ip_address
          end_ip_address   = rule.end_ip_address
        }
      ]
    ]) : item.key => item
  }
}

resource "azurerm_postgresql_flexible_server_database" "database" {
  for_each = local.databases

  name      = each.value.name
  server_id = azurerm_postgresql_flexible_server.server[each.value.server_key].id
  collation = each.value.collation
  charset   = each.value.charset
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "firewall_rule" {
  for_each = local.firewall_rules

  name             = each.value.name
  server_id        = azurerm_postgresql_flexible_server.server[each.value.server_key].id
  start_ip_address = each.value.start_ip_address
  end_ip_address   = each.value.end_ip_address
}
