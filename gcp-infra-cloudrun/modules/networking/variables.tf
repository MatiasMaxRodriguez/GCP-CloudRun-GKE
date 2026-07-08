variable "project_id" {
  description = "ID del proyecto de GCP"
  type        = string
}

variable "region" {
  description = "Región donde se creará la subred"
  type        = string
}

variable "vpc_cidr" {
  description = "Rango CIDR para la subred privada"
  type        = string
  default     = "10.0.1.0/24"
}