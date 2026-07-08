variable "project_id" {
  type        = string
  description = "El ID del proyecto de GCP"
}

variable "region" {
  type        = string
  description = "La región donde se desplegará la base de datos"
}

variable "vpc_id" {
  type        = string
  description = "El ID de la VPC (proporcioando por el módulo de networking)"
}

variable "db_version" {
  type        = string
  default     = "POSTGRES_15" # O MYSQL_8_0 según lo que prefieras para tu app Node.js
  description = "Versión del motor de base de datos en Cloud SQL"
}

# Variable nueva para controlar la dependencia del Peering de red
variable "private_network_connection_id" {
  type        = string
  description = "ID del peering de red (garantiza que la BD espere a que la red privada esté lista)"
}