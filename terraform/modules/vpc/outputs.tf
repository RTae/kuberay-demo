output "vpc_network_name" {
  description = "The name of the VPC network"
  value       = google_compute_network.vpc.name
}

output "subnets" {
  description = "The list of subnets created in the VPC"
  value       = [for subnet in google_compute_subnetwork.subnet : {
    name               = subnet.name
    primary_ip_range   = subnet.ip_cidr_range
    secondary_ip_ranges = [
      for secondary in subnet.secondary_ip_range : {
        range_name    = secondary.range_name
        ip_cidr_range = secondary.ip_cidr_range
      }
    ]
  }]
}