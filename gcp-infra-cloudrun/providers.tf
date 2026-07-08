terraform {
  required_version = ">= 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
  }
}

# Configuramos el provider de Google con tus variables globales
provider "google" {
  project = var.project_id
  region  = var.region
}

# Obtenemos un token de autenticación dinámico de tu cuenta de GCP
data "google_client_config" "default" {}

# Configuramos el provider de Kubernetes para que use el clúster que va a crear el módulo de GKE
provider "kubernetes" {
  host                   = "https://${module.gke.cluster_endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.cluster_ca_certificate)
}