output "db_username" {
  value = module.db.db_instance_username
}

output "db_endpoint" {
  value = module.db.db_instance_endpoint
}

output "db_password" {
  value     = random_password.db_password.result
  sensitive = true
}
