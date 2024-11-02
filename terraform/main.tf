data "google_project" "project" {
  project_id = var.project_id
}

module "network" {
  source   = "./modules/vpc"

  vpc_name = "tae-test"
  subnets  = [
    {
      name          = "node"
      ip_cidr_range = "10.0.0.0/22"
      region        = var.region
      secondary_ip_ranges = [
        {
            range_name    = "pod"
            ip_cidr_range = "192.168.0.0/18"
        },
        {
            range_name    = "service"
            ip_cidr_range = "192.169.0.0/18"
        },
      ]
    },
  ]
}

module "cluster" {
  source   = "./modules/gke"

  cluster_name  = "tae-test"
  region        = var.region
  network       = module.network.vpc_network_name
  subnetwork    = module.network.subnets[0].name

  pod_range_name              = "pod"
  service_range_name          = "service"
  
  node_pools = [
    {
      name              = "common"
      zone              = "c"
      machine_type      = "n1-standard-4"
      node_count        = 1
      preemptible       = true
      min_node_count    = 1
      max_node_count    = 1
      disk_size_gb      = 128
      max_pods_per_node = 60
      labels            = {
        node      = "common"
        node_type = "cpu"
      }
      taints            = []
    },
    {
      name              = "head"
      zone              = "c"
      machine_type      = "n1-standard-4"
      node_count        = 1
      preemptible       = true
      min_node_count    = 1
      max_node_count    = 1
      disk_size_gb      = 128
      max_pods_per_node = 60
      labels            = {
        node      = "ray-head"
        node_type = "cpu"
      }
      taints            = [
        {
          key    = "node"
          value  = "ray_head"
          effect = "NO_SCHEDULE"
        }
      ]
    },
    {
      name              = "worker-small"
      zone              = "c"
      machine_type      = "n1-standard-8"
      node_count        = 1
      preemptible       = true
      min_node_count    = 1
      max_node_count    = 1
      disk_size_gb      = 128
      gpu_type          = "nvidia-tesla-t4"
      gpu_count         = 1
      max_pods_per_node = 60
      labels         = {
        node            = "ray-worker"
        node_type       = "gpu"
      }
      taints         = [
        {
          key    = "node"
          value  = "ray_worker"
          effect = "NO_SCHEDULE"
        },
        {
          key    = "type"
          value  = "small"
          effect = "NO_SCHEDULE"
        }
      ]
    },
    {
      name              = "worker-large"
      zone              = "c"
      machine_type      = "a3-highgpu-1g"
      node_count        = 1
      preemptible       = true
      min_node_count    = 0
      max_node_count    = 3
      disk_size_gb      = 128
      disk_type         = "pd-ssd"
      gpu_type          = "nvidia-h100-80gb"
      gpu_count         = 1
      max_pods_per_node = 60
      labels         = {
        node            = "ray-worker"
        node_type       = "gpu"
      }
      taints         = [
        {
          key    = "node"
          value  = "ray_worker"
          effect = "NO_SCHEDULE"
        },
        {
          key    = "type"
          value  = "large"
          effect = "NO_SCHEDULE"
        }
      ]
    }
  ]

  depends_on = [
    module.network
  ]
}

module "gcs" {
  source   = "./modules/gcs"

  name     = "train-checkpoint"
  location = var.region
  bucket_members = [
    {
      member = "principal://iam.googleapis.com/projects/${data.google_project.project.number}/locations/global/workloadIdentityPools/${var.project_id}.svc.id.goog/subject/ns/workspace/sa/demo1",
      role   = "roles/storage.objectUser"
    }
  ]
} 