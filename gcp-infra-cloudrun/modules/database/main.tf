# 1. Creamos una IP privada dentro de la VPC para Cloud SQL (Private Services Access)
resource "google_compute_global_address" "private_ip_address" {
  name          = "database-private-ip-alloc"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = var.vpc_id
}

# 2. Establecemos el peering de red con los servicios de Google
#resource "google_service_networking_connection" "private_vpc_connection" {
#  network                 = var.vpc_id
#  service                 = "servicenetworking.googleapis.com"
#  reserved_address_ranges = [google_compute_global_address.private_ip_address.name]
#}

# 3. Instancia de Cloud SQL
resource "google_sql_database_instance" "instance" {
  name             = "mi-proyecto-db-instance"
  region           = var.region
  database_version = var.db_version
  
  # Depende de que la conexión privada esté lista
  depends_on = [var.private_network_connection_id]

  settings {
    tier = "db-f1-micro" # Económica para desarrollo/testing

    ip_configuration {
      ipv4_enabled    = false # Desactivamos IP pública por seguridad
      private_network = var.vpc_id
    }
  }
}

# 4. Base de datos lógica dentro de la instancia
resource "google_sql_database" "database" {
  name     = "mi_proyecto_db"
  instance = google_sql_database_instance.instance.name
}

# 5. Usuario para que Node.js se conecte
resource "google_sql_user" "users" {
  name     = "app_user"
  instance = google_sql_database_instance.instance.name
  password = "UnPasswordSeguroDePrueba123" # En producción usaríamos Secret Manager
}