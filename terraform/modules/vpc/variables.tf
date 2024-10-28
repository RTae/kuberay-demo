variable "vpc_name" {
  description = "Name of the VPC network"
  type        = string
}

variable "subnets" {
  description = "List of subnet configurations, including optional secondary ranges"
  type = list(object({
    name                = string
    ip_cidr_range       = string
    region              = string
    secondary_ip_ranges = optional(list(object({
      range_name    = string
      ip_cidr_range = string
    })), [])
  }))
}