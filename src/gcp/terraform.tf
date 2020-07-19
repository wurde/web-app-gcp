terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.29"
      region  = "us-central1"
    }

    google-beta = {
      source  = "terraform-providers/google-beta"
      version = ">= 3.29"
      region  = "us-central1"
    }
  }
}
