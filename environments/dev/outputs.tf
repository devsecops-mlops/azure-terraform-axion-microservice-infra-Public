output "dev_resource_group_ids" {
  value = module.resource_groups.resource_group_ids
}

output "dev_acr_login_servers" {
  value = module.acr.acr_login_servers
}

output "dev_aks_ids" {
  value = module.aks.aks_ids
}

output "dev_postgresql_server_ids" {
  value = module.postgresql.server_ids
}

output "dev_postgresql_server_fqdns" {
  value = module.postgresql.server_fqdns
}

output "dev_postgresql_database_ids" {
  value = module.postgresql.database_ids
}

output "dev_postgresql_administrator_logins" {
  value = module.postgresql.administrator_logins
}
