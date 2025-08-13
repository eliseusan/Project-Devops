# Configuração do provedor Google Cloud
terraform {
  required_version = ">= 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
  
  # Configuração do backend para salvar o state no Google Cloud Storage
  backend "gcs" {
    bucket = "terraform-state-api-escolar-2"
    prefix = "artifact-registry"
  }
}

# Configuração do provedor Google Cloud
provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# Habilitar a API do Artifact Registry
resource "google_project_service" "artifact_registry" {
  project = var.project_id
  service = "artifactregistry.googleapis.com"

  disable_dependent_services = true
  disable_on_destroy         = false
}

# Criar o Artifact Registry
resource "google_artifact_registry_repository" "api_escolar" {
  location      = var.region
  repository_id = "api-escolar-repo"
  description   = "Registry para a API Escolar"
  format        = "DOCKER"

  docker_config {
    immutable_tags = false
  }

  depends_on = [google_project_service.artifact_registry]
}

# Configurar permissões IAM para o registry
#resource "google_artifact_registry_repository_iam_member" "viewer" {
 # location   = google_artifact_registry_repository.api_escolar.location
  #repository = google_artifact_registry_repository.api_escolar.name
  #role       = "roles/artifactregistry.reader"
  #member     = "serviceAccount:${var.service_account_email}"
#}

#resource "google_artifact_registry_repository_iam_member" "writer" {
 # location   = google_artifact_registry_repository.api_escolar.location
  #repository = google_artifact_registry_repository.api_escolar.name
  #role       = "roles/artifactregistry.writer"
  #member     = "serviceAccount:${var.service_account_email}"
#}
