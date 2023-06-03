## create all namespaces that got requested
resource "kubernetes_namespace" "namespace" {
  metadata {
    name = "quick-start"
  }
}

# example.com
resource "azurerm_private_dns_zone" "pdns" {
  name                = "example.com"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "kubernetes_service_v1" "nginx" {
  metadata {
    annotations = {
      "service.beta.kubernetes.io/azure-load-balancer-internal" : "true"
      "external-dns.alpha.kubernetes.io/hostname"          = "server.example.com"
      "external-dns.alpha.kubernetes.io/internal-hostname" = "server-clusterip.example.com"
    }
    name = "nginx-svc"
  }
  spec {
    port {
      port        = 80
      protocol    = "TCP"
      target_port = "80"
    }
    selector = {
      "app" = "nginx"
    }
    type = "LoadBalancer"
  }
}

resource "helm_release" "nginx_controller" {
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  name       = "ingress-nginx"

  set {
    name  = "controller.publishService.enabled"
    value = "true"
  }
}

resource "kubernetes_service_v1" "nginx-svc" {
  metadata {
    name = "nginx-svc-clusterip"
  }
  spec {
    port {
      port        = 80
      protocol    = "TCP"
      target_port = "80"
    }
    selector = {
      "app" = "nginx"
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_ingress_v1" "nginx" {
  metadata {
    name = "nginx"
  }
  spec {
    ingress_class_name = "nginx"
    rule {
      host = "server.example.com"
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "nginx-svc-clusterip"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}

# -------------------------------
# example2.com
resource "azurerm_private_dns_zone" "pdns2" {
  name                = "example2.com"
  resource_group_name = azurerm_resource_group.rg.name
}


resource "kubernetes_service_v1" "nginx2" {
  metadata {
    annotations = {
      "service.beta.kubernetes.io/azure-load-balancer-internal" : "true"
      "external-dns.alpha.kubernetes.io/hostname"          = "server.example2.com"
      "external-dns.alpha.kubernetes.io/internal-hostname" = "server-clusterip.example2.com"
    }
    name = "nginx-svc2"
  }
  spec {
    port {
      port        = 80
      protocol    = "TCP"
      target_port = "80"
    }
    selector = {
      "app" = "nginx2"
    }
    type = "LoadBalancer"
  }
}

resource "helm_release" "nginx_controller2" {
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  name       = "ingress-nginx2"

  set {
    name  = "controller.publishService.enabled"
    value = "true"
  }
}

resource "kubernetes_service_v1" "nginx-svc2" {
  metadata {
    name = "nginx-svc-clusterip2"
  }
  spec {
    port {
      port        = 80
      protocol    = "TCP"
      target_port = "80"
    }
    selector = {
      "app" = "nginx2"
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_ingress_v1" "nginx2" {
  metadata {
    name = "nginx2"
  }
  spec {
    ingress_class_name = "nginx2"
    rule {
      host = "server.example2.com"
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "nginx-svc-clusterip2"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}