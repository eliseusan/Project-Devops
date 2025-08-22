# Configuração do Cluster GKE
resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.region
  project  = var.project_id

  # Configurações de rede
  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name

  # Configurações de segurança
  enable_shielded_nodes = true
  enable_secure_boot   = true

  # Configurações de monitoramento
  enable_workload_identity = true
  monitoring_config {
    enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]
    managed_prometheus {
      enabled = true
    }
  }

  # Configurações de logging
  logging_config {
    enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  }

  # Configurações de rede
  ip_allocation_policy {
    cluster_ipv4_cidr_block  = var.pods_cidr
    services_ipv4_cidr_block = var.services_cidr
  }

  # Configurações de master
  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  # Configurações de nodes
  node_config {
    machine_type = var.machine_type
    disk_size_gb = var.disk_size_gb
    disk_type    = "pd-ssd"

    # Configurações de segurança
    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    # Configurações de labels
    labels = {
      environment = var.environment
      app        = "api-escolar"
    }

    # Configurações de taints
    taint {
      key    = "node-role"
      value  = "api-escolar"
      effect = "NO_SCHEDULE"
    }

    # Configurações de recursos
    resource_labels = {
      environment = var.environment
      project     = var.project_id
    }

    # Configurações de metadata
    metadata = {
      disable-legacy-endpoints = "true"
    }

    # Configurações de oauth scopes
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  # Configurações de autoscaling
  node_pool {
    name       = "default-pool"
    location   = var.region
    node_count = var.initial_node_count

    autoscaling {
      min_node_count = var.min_node_count
      max_node_count = var.max_node_count
    }

    node_config {
      machine_type = var.machine_type
      disk_size_gb = var.disk_size_gb
      disk_type    = "pd-ssd"

      workload_metadata_config {
        mode = "GKE_METADATA"
      }

      labels = {
        environment = var.environment
        app        = "api-escolar"
      }

      taint {
        key    = "node-role"
        value  = "api-escolar"
        effect = "NO_SCHEDULE"
      }

      resource_labels = {
        environment = var.environment
        project     = var.project_id
      }

      metadata = {
        disable-legacy-endpoints = "true"
      }

      oauth_scopes = [
        "https://www.googleapis.com/auth/logging.write",
        "https://www.googleapis.com/auth/monitoring",
        "https://www.googleapis.com/auth/devstorage.read_only",
        "https://www.googleapis.com/auth/cloud-platform"
      ]
    }
  }

  # Configurações de addons
  addons_config {
    http_load_balancing {
      disabled = false
    }
    horizontal_pod_autoscaling {
      disabled = false
    }
    network_policy_config {
      disabled = false
    }
    istio_config {
      disabled = true
    }
    cloudrun_config {
      disabled = true
    }
    dns_cache_config {
      enabled = true
    }
    gce_persistent_disk_csi_driver_config {
      enabled = true
    }
    gcp_filestore_csi_driver_config {
      enabled = true
    }
    gke_backup_agent_config {
      enabled = true
    }
    config_connector_config {
      enabled = false
    }
    gcs_fuse_csi_driver_config {
      enabled = true
    }
    gcp_persistent_disk_csi_driver_config {
      enabled = true
    }
  }

  # Configurações de rede
  network_policy {
    enabled = true
    provider = "CALICO"
  }

  # Configurações de pod security policy
  pod_security_policy_config {
    enabled = true
  }

  # Configurações de release channel
  release_channel {
    channel = "REGULAR"
  }

  # Configurações de maintenance
  maintenance_policy {
    daily_maintenance_window {
      start_time = "03:00"
    }
  }

  # Configurações de lifecycle
  lifecycle {
    ignore_changes = [
      node_config.0.workload_metadata_config,
      node_pool.0.node_config.0.workload_metadata_config
    ]
  }
}

# Outputs
output "cluster_name" {
  value = google_container_cluster.primary.name
}

output "cluster_endpoint" {
  value = google_container_cluster.primary.endpoint
}

output "cluster_ca_certificate" {
  value = google_container_cluster.primary.master_auth[0].cluster_ca_certificate
}

output "cluster_location" {
  value = google_container_cluster.primary.location
}

output "cluster_project" {
  value = google_container_cluster.primary.project
} 