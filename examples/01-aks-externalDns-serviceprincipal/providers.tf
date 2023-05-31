terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.57.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">=2.20.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">=3.5.1"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.9.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {}
}

provider "kubernetes" {
  host = azurerm_kubernetes_cluster.aks.kube_config[0].host

  client_certificate     = base64decode(azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.aks.kube_config[0].client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config[0].cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    client_certificate     = base64decode(azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.aks.kube_config[0].client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config[0].cluster_ca_certificate)
    host                   = azurerm_kubernetes_cluster.aks.kube_config[0].host
  }
}

provider "random" {
  # Configuration options
}
