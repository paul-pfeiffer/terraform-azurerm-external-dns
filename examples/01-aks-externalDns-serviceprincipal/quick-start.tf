## create all namespaces that got requested
resource "kubernetes_namespace" "namespace" {
  metadata {
    name = "quick-start"
  }
}

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
          path = "/"
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