locals {
  aks-cluster-name = "mycluster-${random_string.my_random_string.result}"
}

resource "azurerm_kubernetes_cluster" "aks" {
  location            = "westeurope"
  name                = local.aks-cluster-name
  resource_group_name = azurerm_resource_group.rg.name
  azure_policy_enabled = true

  identity {
    type = "SystemAssigned"
  }

  dns_prefix = local.aks-cluster-name

  default_node_pool {
    name       = "default"
    vm_size    = "Standard_D2_v3"
    node_count = 1

    upgrade_settings {
      drain_timeout_in_minutes      = 0
      max_surge                     = "10%"
      node_soak_duration_in_minutes = 0
    }

  }
  lifecycle {
    ignore_changes = [
      microsoft_defender
    ]
  }
}

data "azurerm_subscription" "current" {}
data "azuread_client_config" "current" {}

resource "azuread_service_principal" "sp" {
  client_id                    = azuread_application.sp_app.client_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal_password" "sp_pw" {
  service_principal_id = azuread_service_principal.sp.id
}

resource "azuread_application" "sp_app" {
  display_name = "sp-externaldns"
  owners       = [data.azuread_client_config.current.object_id]
}

module "external_dns" {
  source                = "../../"
  azure_client_id       = azuread_service_principal.sp.client_id
  azure_object_id       = azuread_service_principal.sp.object_id
  azure_client_secret   = azuread_service_principal_password.sp_pw.value
  azure_tenant_id       = data.azurerm_subscription.current.tenant_id
  azure_subscription_id = data.azurerm_subscription.current.subscription_id
  resource_group_name   = var.dns_zone_resource_group_name
  dns_provider          = "azure"
  set_permission        = true

  domain_filters = [
    var.dns_zone_name
  ]
}