variable "project_id" {
  description = "Project ID"
  type        = string
  default     = "rtae-lab"
}

variable "region" {
  description = "Service Region"
  type        = string
  default     = "asia-southeast1"
}

variable "bucket_tfstate_name" {
  description = "GCS bucket name for keeping TF State"
  type        = string
  default     = "rtae-lab-tfstate-12dkl"
}