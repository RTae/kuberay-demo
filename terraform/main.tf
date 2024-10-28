module "network" {
  source   = "./modules/vpc"

  vpc_name = "tae-test"
  subnets  = [
    {
      name          = "node"
      ip_cidr_range = "10.0.0.0/24"
      region        = var.region
      secondary_ip_ranges = [
        {
            range_name    = "pod"
            ip_cidr_range = "192.168.0.0/24"
        },
        {
            range_name    = "service"
            ip_cidr_range = "192.168.1.0/24"
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
      name           = "main"
      zone           = "c"
      machine_type   = "n1-standard-4"
      node_count     = 1
      preemptible    = true
      min_node_count = 1
      max_node_count = 1
      disk_size_gb   = 64
      gpu_type       = "nvidia-tesla-t4"
      gpu_count      = 1
    }
  ]

  depends_on = [
    module.network
  ]
}