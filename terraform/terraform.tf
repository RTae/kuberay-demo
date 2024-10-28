terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.8.0"
    }
  }

  backend "gcs" {
    bucket  = " rtae-lab-tfstate-12dkl"
    prefix  = "terraform/state"
  }
}