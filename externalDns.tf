resource "helm_release" "external_dns" {
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "external-dns"
  name             = "external-dns"
  namespace        = var.external_dns_namespace
  create_namespace = true
  version          = "6.26.5"
  set {
    name  = "provider"
    value = var.dns_provider
  }

  set {
    name  = "azure.resourceGroup"
    value = var.resource_group_name
  }

  set {
    name  = "azure.aadClientId"
    value = var.azure_client_id
  }

  set_sensitive {
    name  = "azure.aadClientSecret"
    value = var.azure_client_secret
  }

  set {
    name  = "azure.tenantId"
    value = var.azure_tenant_id
  }

  set {
    name  = "azure.subscriptionId"
    value = var.azure_subscription_id
  }

  set {
    name  = "domainFilters"
    value = "{${join(",", var.domain_filters)}}"
  }
}