variable "name" {
  description = "Bucket name"
  type = string
}

variable "location" {
  description = "Bucket location"
  type        = string
  default     = "asia-southeast1"
}

variable "bucket_members" {
  description = "List of IAM member user"
  type = list(object({
    role   = string
    member = string
  }))
}