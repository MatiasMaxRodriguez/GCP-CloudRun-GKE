variable "project_id" {
  type        = string
  description = "El ID del proyecto de GCP"
}

variable "region" {
  type        = string
  description = "La región donde se desplegará el cómputo"
}

variable "vpc_id" {
  type        = string
  description = "El ID de la VPC para el conector Serverless"
}

variable "db_instance_ip" {
  type        = string
  description = "La IP privada de Cloud SQL (provista por el módulo database)"
}

variable "db_name" {
  type        = string
  description = "Nombre de la base de datos lógica"
}