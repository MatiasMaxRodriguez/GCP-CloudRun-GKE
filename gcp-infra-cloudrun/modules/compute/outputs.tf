output "app_url" {
  value       = google_cloud_run_v2_service.node_app.uri
  description = "URL pública de la aplicación en Cloud Run"
}

output "repository_url" {
  value       = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.node_repo.repository_id}"
  description = "Ruta del repositorio de Artifact Registry para hacer el docker push"
}