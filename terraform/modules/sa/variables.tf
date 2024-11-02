variable "project_id" {
  description = "Project ID"
  type        = string
  default     = "rtae-lab"
}

variable "display_name" {
  type        = string
  description = "The display name of the Service account"
}

variable "description" {
  type        = string
  description = "The description for the Service account"
}

variable "name" {
  type        = string
  description = "The name of the service account"
}

variable "iam_roles" {
  type        = list(string)
  description = "The roles to be granted to the members"
  default     = []
}

variable "workload_identity_user_members" {
  type        = list(string)
  description = "The workload identity user member"
  default     = []
}