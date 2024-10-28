resource "google_compute_network" "vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  for_each                 = { for subnet in var.subnets : subnet.name => subnet }
  name                     = each.value.name
  ip_cidr_range            = each.value.ip_cidr_range
  region                   = each.value.region
  network                  = google_compute_network.vpc.self_link
  private_ip_google_access = true

  # Add secondary IP ranges if they are provided
  dynamic "secondary_ip_range" {
    for_each = each.value.secondary_ip_ranges
    content {
      range_name    = secondary_ip_range.value.range_name
      ip_cidr_range = secondary_ip_range.value.ip_cidr_range
    }
  }
}