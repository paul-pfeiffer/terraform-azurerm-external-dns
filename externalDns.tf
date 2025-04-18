resource "helm_release" "external_dns" {
  repository       = "oci://registry-1.docker.io/bitnamicharts"
  chart            = "external-dns"
  name             = "external-dns"
  namespace        = var.external_dns_namespace
  create_namespace = var.external_dns_create_namespace
  version          = var.external_dns_version
  

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

  dynamic "set" {
    for_each = var.resources_requests.cpu != null ? [1] : []
    content {
      name  = "resources.requests.cpu"
      value = var.resources_requests.cpu
    }
  }

  dynamic "set" {
    for_each = var.resources_requests.memory != null ? [1] : []
    content {
      name  = "resources.requests.memory"
      value = var.resources_requests.memory
    }
  }

  dynamic "set" {
    for_each = var.resources_limits.cpu != null ? [1] : []
    content {
      name  = "resources.limits.cpu"
      value = var.resources_limits.cpu
    }
  }

  dynamic "set" {
    for_each = var.resources_limits.memory != null ? [1] : []
    content {
      name  = "resources.limits.memory"
      value = var.resources_limits.memory
    }
  }
}