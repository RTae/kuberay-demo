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
      disk_size_gb      = 64
      max_pods_per_node = 40
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
      disk_size_gb      = 64
      max_pods_per_node = 40
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
      name              = "worker"
      zone              = "c"
      machine_type      = "n1-standard-4"
      node_count        = 1
      preemptible       = true
      min_node_count    = 1
      max_node_count    = 1
      disk_size_gb      = 64
      gpu_type          = "nvidia-tesla-t4"
      gpu_count         = 1
      max_pods_per_node = 40
      labels         = {
        node            = "ray-worker"
        node_type       = "gpu"
      }
      taints         = [
        {
          key    = "node"
          value  = "ray_worker"
          effect = "NO_SCHEDULE"
        }
      ]
    }
  ]

  depends_on = [
    module.network
  ]
}