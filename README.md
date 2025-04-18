# externalDns Azure (public/private) DNS Zone integration
Integration of externalDNS with Azure private DNS zones.
Public Azure DNS Zones will be supported soon.

This module is published in the Terraform Module Registry https://registry.terraform.io/modules/paul-pfeiffer/workload-identity/azurerm/latest

This guide follows the official documentation at https://github.com/kubernetes-sigs/external-dns/blob/master/docs/tutorials/azure-private-dns.md


This module is published in the Terraform Module Registry https://registry.terraform.io/modules/paul-pfeiffer/external-dns/azurerm/latest

Pull Request are Welcome!

## Usage
```hcl
module "external_dns" {
  source                = "paul-pfeiffer/external-dns/azurerm"
  version               = "0.0.1"
  azure_client_id       = azuread_service_principal.sp.application_id  # application (client) id of service principal
  azure_object_id       = azuread_service_principal.sp.object_id       # object id of service principal
  azure_client_secret   = azuread_service_principal_password.sp_pw.value # sp secret
  azure_tenant_id       = data.azurerm_subscription.current.tenant_id
  azure_subscription_id = data.azurerm_subscription.current.subscription_id
  resource_group_name   = "myrg" # 
  dns_provider          = "azure-private-dns" # currently only azure-private-dns supported
  set_permission        = true # if set to true permission for the service principal are set 
  # automatically. This includes reader permission on the resource 
  # group and private dns zone contributor permission on the private dns zone
  external_dns_namespace = "external-dns" # defaults to 'default' namespace

  resources_requests = {
    cpu    = "100m"
    memory = "128Mi"
  }

  resources_limits = {
    cpu    = "500m"
    memory = "256Mi"
  }
  
  domain_filters = [
    azurerm_private_dns_zone.pdns.name
  ]
}
```

## Usecases
This module sets creates user assigned identities and configures federated identity credentials so that it will work with azure workload identity.

