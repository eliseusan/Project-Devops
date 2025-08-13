# Outputs do Artifact Registry
output "repository_id" {
  description = "ID do repositório criado"
  value       = google_artifact_registry_repository.api_escolar.repository_id
}

output "repository_name" {
  description = "Nome completo do repositório"
  value       = google_artifact_registry_repository.api_escolar.name
}

output "repository_location" {
  description = "Localização do repositório"
  value       = google_artifact_registry_repository.api_escolar.location
}

output "repository_url" {
  description = "URL do repositório para push/pull de imagens"
  value       = "${google_artifact_registry_repository.api_escolar.location}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.api_escolar.repository_id}"
}

output "docker_tag_example" {
  description = "Exemplo de comando para fazer tag de uma imagem Docker"
  value       = "docker tag api-escolar:latest ${google_artifact_registry_repository.api_escolar.location}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.api_escolar.repository_id}/api-escolar:latest"
}

output "docker_push_example" {
  description = "Exemplo de comando para fazer push de uma imagem Docker"
  value       = "docker push ${google_artifact_registry_repository.api_escolar.location}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.api_escolar.repository_id}/api-escolar:latest"
}

# # Outputs do bucket do state
# output "terraform_state_bucket" {
#   description = "Nome do bucket criado para o state do Terraform"
#   value       = google_storage_bucket.terraform_state.name
# }

# output "terraform_state_bucket_url" {
#   description = "URL do bucket do state"
#   value       = "gs://${google_storage_bucket.terraform_state.name}"
# }
