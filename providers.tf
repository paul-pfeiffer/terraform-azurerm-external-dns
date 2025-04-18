terraform {
  required_version = ">=1.2.0"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">=2.18.1"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.42.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = ">=2.9.0"
    }
  }
}