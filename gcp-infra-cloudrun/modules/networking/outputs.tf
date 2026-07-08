output "vpc_id" {
  description = "El ID de la VPC creada"
  value       = google_compute_network.custom_vpc.id
}

output "vpc_name" {
  description = "El nombre de la VPC creada"
  value       = google_compute_network.custom_vpc.name
}

output "private_subnet_id" {
  description = "El ID de la subred privada"
  value       = google_compute_subnetwork.subnet_id.id
}

output "private_network_connection_id" {
  description = "El ID del peering para servicios privados (garantiza orden de ejecución en Terraform)"
  value       = google_service_networking_connection.private_vpc_connection.id
}