# variables.tf en la raíz

variable "project_id" {
  description = "El ID del proyecto de Google Cloud donde se desplegarán los recursos."
  type        = string
}

variable "region" {
  description = "La región por defecto para los recursos de GCP."
  type        = string
  default     = "us-central1"
}

variable "environment" {
  description = "Entorno del proyecto (dev, staging, prod)."
  type        = string
  default     = "dev"
}