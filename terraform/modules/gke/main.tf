resource "google_service_account" "cluster_sa" {
  account_id   = "${var.cluster_name}-sa"
  display_name = "${var.cluster_name} Service Account"
}

resource "google_container_cluster" "cluster" {
  name       = var.cluster_name
  location = "${var.region}-c"

  network    = var.network
  subnetwork = var.subnetwork

  remove_default_node_pool = true
  deletion_protection      = false

  ip_allocation_policy {
    cluster_secondary_range_name  = var.pod_range_name
    services_secondary_range_name = var.service_range_name
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  addons_config {
    http_load_balancing {
      disabled = false
    }
    gcs_fuse_csi_driver_config {
      enabled = true
    }
  }

  node_pool {
    name = "default-pool"
  }

  lifecycle {
    ignore_changes = [node_pool]
  }
}

resource "google_container_node_pool" "node_pool" {
  for_each    = { for np in var.node_pools : np.name => np }

  name        = each.value.name
  location    = "${var.region}-c"
  cluster     = google_container_cluster.cluster.name
  node_count  = each.value.node_count

  node_config {
    machine_type    = each.value.machine_type
    preemptible     = each.value.preemptible
    service_account = google_service_account.cluster_sa.email
    disk_size_gb    = each.value.disk_size_gb
    disk_type       = each.value.disk_type
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/trace.append",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
    ]

    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    dynamic "guest_accelerator" {
      for_each = each.value.gpu_count > 0 ? [each.value] : []
      content {
        type  = guest_accelerator.value.gpu_type
        count = guest_accelerator.value.gpu_count
      }
    }

    # Using labels from variables
    labels = each.value.labels

    # Using taints from variables
    dynamic "taint" {
      for_each = each.value.taints
      content {
        key    = taint.value.key
        value  = taint.value.value
        effect = taint.value.effect
      }
    }
  }

  max_pods_per_node = each.value.max_pods_per_node

  autoscaling {
    min_node_count = each.value.min_node_count
    max_node_count = each.value.max_node_count
  }

  # Additional configurations
  management {
    auto_repair  = true
    auto_upgrade = true
  }

  depends_on = [
    google_container_cluster.cluster,
    google_service_account.cluster_sa
  ]
}