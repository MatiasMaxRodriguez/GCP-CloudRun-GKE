# 1. Creación de la VPC personalizada
resource "google_compute_network" "custom_vpc" {
  name                    = "app-vpc-prod"
  auto_create_subnetworks = false
  project                 = var.project_id
}

# 2. Creación de la Subred Privada
resource "google_compute_subnetwork" "subnet_id" {
  name                     = "app-private-subnet-${var.region}"
  ip_cidr_range            = var.vpc_cidr
  region                   = var.region
  network                  = google_compute_network.custom_vpc.id
  private_ip_google_access = true # Permite que los recursos accedan a las APIs de Google por IP interna

  # Rango secundario exclusivo para los Pods de Kubernetes
  secondary_ip_range {
    range_name    = "gke-pods-range"
    ip_cidr_range = "10.48.0.0/14" # Rango amplio para que entren muchos Pods
  }

  # Rango secundario exclusivo para los Services de Kubernetes
  secondary_ip_range {
    range_name    = "gke-services-range"
    ip_cidr_range = "10.52.0.0/20" # Rango para los balanceadores internos
  }
}

# 3. Reserva de un rango de direcciones IP internas para el acceso privado a servicios (Cloud SQL)
resource "google_compute_global_address" "private_ip_alloc" {
  name          = "google-managed-services-range"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16 # Reserva un bloque /16 para servicios administrados por Google
  network       = google_compute_network.custom_vpc.id
}

# 4. Creación de la conexión privada (VPC Peering interna con los servicios administrados de Google)
resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.custom_vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_alloc.name]
}