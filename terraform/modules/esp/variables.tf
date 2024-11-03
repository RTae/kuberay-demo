variable "project_id" {
  type        = string
  description = "Project ID"
}

variable "name" {
  type        = string
  description = "Name of the endpoint"
}

variable "loadbalancer_ip" {
  type        = string
  description = "Share IP for the loadbalancer"
  default     = "0.0.0.0"
}

variable "invoker_members" {
  type        = list(string)
  description = "The list of the user which could invoker this service"
  default     = []
}