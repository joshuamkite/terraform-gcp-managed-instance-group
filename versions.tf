provider "google" {
  project        = var.project
  region         = var.region
  default_labels = var.default_labels
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">=3.5.0"
    }
  }
}
