# 1. Definición del Clúster de GKE (Forma estándar/privada)
resource "google_container_cluster" "primary" {
  name     = "gke-mongodb-cluster"
  location = var.region
  project  = var.project_id

  # Indicamos la red y subred que creamos en el módulo de networking
  network    = var.vpc_id
  subnetwork = var.subnet_id

  # Es una buena práctica en desarrollo eliminar el node pool por defecto 
  # y crear uno personalizado para administrar mejor los recursos.
  remove_default_node_pool = true
  initial_node_count       = 1

  # Habilitamos IP Alias para que los Pods tengan IPs nativas de la VPC
  ip_allocation_policy {
    cluster_secondary_range_name  = "gke-pods-range" # Asegurate que coincida con tus outputs de red
    services_secondary_range_name = "gke-services-range"
  }

  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"
}

# 2. Node Pool personalizado para MongoDB
resource "google_container_node_pool" "primary_nodes" {
  name       = "mongo-node-pool"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  project    = var.project_id
  node_count = 1 # Para un lab con 1 nodo es suficiente; podés subirlo a 2 o 3 si querés réplicas

  node_config {
    preemptible  = true # Para ahorrar costos en tu laboratorio personal
    machine_type = "e2-medium" # Capacidad equilibrada para correr Mongo y el SO

    # Permisos necesarios para que el nodo interactúe con el resto de GCP
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only" # Para descargar imágenes si fuera necesario
    ]

    labels = {
      env = "production"
      app = "mongodb"
    }
  }
}