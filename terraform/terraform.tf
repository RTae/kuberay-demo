terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.8.0"
    }
  }

  backend "gcs" {
    bucket  = var.bucket_tfstate_name
    prefix  = "terraform/state"
  }
}