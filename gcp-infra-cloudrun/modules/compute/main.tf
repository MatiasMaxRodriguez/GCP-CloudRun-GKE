# 1. Repositorio de Artifact Registry para las imágenes Docker de Node.js
resource "google_artifact_registry_repository" "node_repo" {
  location      = var.region
  repository_id = "node-app-repo"
  description   = "Repositorio Docker para la app Node.js"
  format        = "DOCKER"
}

# 2. Conector VPC Serverless (permite a Cloud Run acceder a la IP privada de Cloud SQL)
resource "google_vpc_access_connector" "connector" {
  name          = "cr-vpc-connector"
  region        = var.region
  network       = var.vpc_id
  ip_cidr_range = "10.8.0.0/28" # Un rango chico dedicado exclusivamente al conector
}

# 3. Servicio de Cloud Run para la aplicación Node.js
resource "google_cloud_run_v2_service" "node_app" {
  name     = "node-app-service"
  location = var.region
  ingress  = "INGRESS_TRAFFIC_ALL" # Permite tráfico desde internet

  template {
    # Conectamos Cloud Run al conector de la VPC
    vpc_access {
      connector = google_vpc_access_connector.connector.id
      egress    = "PRIVATE_RANGES_ONLY"
    }

    containers {
      # Imagen temporal para el primer 'apply'. Luego la cambiarás por la tuya de Artifact Registry.
      image = "us-docker.pkg.dev/cloudrun/container/hello:latest"

      ports {
        container_port = 3000 # El puerto en el que escucha tu app Node.js
      }

      # Inyectamos las variables de entorno para que tu código Node.js se conecte a la DB
      env {
        name  = "MONGO_URI"
        value = "mongodb://rootadmin:PassSecureGKE2026@10.52.2.125:27017/tu_base_de_datos?authSource=admin"
      }
      env {
        name  = "DB_HOST"
        value = var.db_instance_ip
      }
      env {
        name  = "DB_NAME"
        value = var.db_name
      }
      env {
        name  = "DB_USER"
        value = "app_user"
      }
      env {
        name  = "DB_PASSWORD"
        value = "UnPasswordSeguroDePrueba123" # Mismo password que pusimos en el módulo database
      }
    }
  }
}

# 4. Permitir acceso público (Unauthenticated) para que cualquiera pueda entrar a la URL de Cloud Run
resource "google_cloud_run_v2_service_iam_binding" "public_access" {
  location = google_cloud_run_v2_service.node_app.location
  name     = google_cloud_run_v2_service.node_app.name
  role     = "roles/run.invoker"
  members = [
    "allUsers"
  ]
}