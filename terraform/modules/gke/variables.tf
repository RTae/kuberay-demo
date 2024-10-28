# Cluster name
variable "cluster_name" {
  description = "The name of the GKE cluster"
  type        = string
}

# Region for the GKE cluster
variable "region" {
  description = "The primary region for the GKE cluster"
  type        = string
}

# VPC network for the GKE cluster
variable "network" {
  description = "The VPC network to deploy the GKE cluster"
  type        = string
}

# Subnetwork for the GKE cluster
variable "subnetwork" {
  description = "The subnetwork to deploy the GKE cluster"
  type        = string
}

variable "pod_range_name" {
  description = "Pod range name"
  type        = string
}

variable "service_range_name" {
  description = "Service range name"
  type        = string
}

# Node pools configuration
variable "node_pools" {
  description = "List of node pools with configuration details for each pool"
  type = list(object({
    name           = string                 # Name of the node pool
    zone           = string                 # Zone for the node pool
    machine_type   = string                 # Machine type for the nodes in this pool
    node_count     = number                 # Initial number of nodes
    preemptible    = bool                   # Whether the nodes are preemptible
    min_node_count = number                 # Minimum number of nodes (for autoscaling)
    max_node_count = number                 # Maximum number of nodes (for autoscaling)
    disk_size_gb   = number                 # Size of the disk in GB
    gpu_type       = optional(string, null) # Type of GPU (e.g., nvidia-tesla-t4)
    gpu_count      = number                 # Number of GPUs per node
    labels         = map(string)
    taints         = list(object({
                        key    = string
                        value  = string
                        effect = string
                      }))
  }))
}
