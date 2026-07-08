output "db_instance_ip" {
  value       = google_sql_database_instance.instance.private_ip_address
  description = "La IP privada de la instancia de Cloud SQL"
}

output "db_name" {
  value       = google_sql_database.database.name
  description = "Nombre de la base de datos"
}