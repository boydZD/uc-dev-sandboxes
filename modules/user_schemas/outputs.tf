output "catalog_name" {
  description = "Name of the created managed sandbox catalog"
  value       = databricks_catalog.sandbox.name
}

output "user_schemas" {
  description = "Map of usernames to their schema full names"
  value = {
    for username, email in local.users_map :
    username => "${databricks_catalog.sandbox.name}.${username}"
  }
}

output "user_volumes" {
  description = "Map of usernames to their volume full names"
  value = {
    for username, email in local.users_map :
    username => "${databricks_catalog.sandbox.name}.${databricks_schema.user_schema[username].name}.my_volume"
  }
}

output "users_processed" {
  description = "List of user emails that were processed"
  value       = values(local.users_map)
}
