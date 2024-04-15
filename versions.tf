terraform {
  required_version = ">= 1.3"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.50, < 6"
    }

    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 4.50, < 6"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.regions[0]
}
