# main.tf en la raíz

#terraform {
#  required_version = ">= 1.5.0"
#  required_providers {
#    google = {
#      source  = "hashicorp/google"
#      version = "~> 5.0"
#    }
#  }
#  # Nota: Para un nivel ACE, lo ideal es usar un backend remoto (Cloud Storage)
#  # pero para empezar a armarlo localmente, podemos dejarlo comentado.
#  # backend "gcs" {
#  #   bucket  = "tu-bucket-terraform-state"
#  #   prefix  = "terraform/state"
#  # }
#}

#provider "google" {
#  project = var.project_id
#  region  = var.region
#}

# -------------------------------------------------------------
# MÓDULOS (Los completaremos paso a paso)
# -------------------------------------------------------------

# Módulo de Red (VPC, Subnets)
module "networking" {
  source     = "./modules/networking"
  project_id = var.project_id
  region     = var.region
}

# Módulo de Base de Datos (Cloud SQL)
module "database" {
  source     = "./modules/database"
  project_id = var.project_id
  region     = var.region
  vpc_id     = module.networking.vpc_id
  # Pasamos el ID del peering desde el módulo de red hacia el de base de datos
  private_network_connection_id = module.networking.private_network_connection_id
}

# Módulo de Cómputo (Cloud Run & Artifact Registry)
module "compute" {
  source     = "./modules/compute"
  project_id = var.project_id
  region     = var.region
  vpc_id         = module.networking.vpc_id
  
  # Pasamos los outputs del módulo de base de datos de forma dinámica
  db_instance_ip = module.database.db_instance_ip
  db_name        = module.database.db_name
}

# Modulo de GKE
module "gke" {
  source     = "./modules/gke"
  project_id = var.project_id
  region     = var.region
  vpc_id     = module.networking.vpc_id
  subnet_id  = module.networking.private_subnet_id
}