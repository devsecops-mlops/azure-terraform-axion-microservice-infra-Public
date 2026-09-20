output "server_ids" {
  description = "Map of PostgreSQL Flexible Server IDs"
  value       = { for k, v in azurerm_postgresql_flexible_server.server : k => v.id }
}

output "server_fqdns" {
  description = "Map of PostgreSQL Flexible Server FQDNs"
  value       = { for k, v in azurerm_postgresql_flexible_server.server : k => v.fqdn }
}

output "database_ids" {
  description = "Map of PostgreSQL Flexible Server Database IDs"
  value       = { for k, v in azurerm_postgresql_flexible_server_database.database : k => v.id }
}

output "administrator_logins" {
  description = "Map of PostgreSQL Flexible Server administrator logins"
  value       = { for k, v in azurerm_postgresql_flexible_server.server : k => v.administrator_login }
}

output "administrator_passwords" {
  description = "Map of PostgreSQL Flexible Server administrator passwords"
  value = {
    for k, v in var.postgresql_servers : k => (
      v.administrator_password != null && v.administrator_password != "" ? v.administrator_password : try(random_password.admin_password[k].result, null)
    )
  }
  sensitive = true
}
