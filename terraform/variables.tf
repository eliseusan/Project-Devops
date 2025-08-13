# Variáveis para configuração do Google Cloud
variable "project_id" {
  description = "ID do projeto Google Cloud"
  type        = string
}

variable "region" {
  description = "Região do Google Cloud"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "Zona do Google Cloud"
  type        = string
  default     = "us-central1-a"
}

variable "service_account_email" {
  description = "Email da service account que terá acesso ao registry"
  type        = string
}
