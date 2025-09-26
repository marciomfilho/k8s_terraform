terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.8"
    }
  }
  required_version = ">= 1.3.0"
}
