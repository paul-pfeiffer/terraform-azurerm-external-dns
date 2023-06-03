data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

resource "azurerm_role_assignment" "dns_rg_reader" {
  count                = var.set_permission ? 1 : 0
  principal_id         = var.azure_object_id
  role_definition_name = "Reader"
  scope                = data.azurerm_resource_group.rg.id
}

# privatedns 
data "azurerm_private_dns_zone" "private_dns_zone" {
  for_each            = toset([for i in var.domain_filters : i if var.dns_provider=="azure-private-dns"])
  name                = each.value
  resource_group_name = var.resource_group_name
}

resource "azurerm_role_assignment" "private_dns_zone_contributor" {
  for_each             = data.azurerm_private_dns_zone.private_dns_zone
  principal_id         = var.azure_object_id
  role_definition_name = "Private DNS Zone Contributor"
  scope                = each.value.id
}

# publicdns
data "azurerm_dns_zone" "public_dns_zone" {
  for_each            = toset([for i in var.domain_filters : i if var.dns_provider=="azure"])
  name                = each.value
  resource_group_name = var.resource_group_name
}

resource "azurerm_role_assignment" "public_dns_zone_contributor" {
  for_each             = data.azurerm_dns_zone.public_dns_zone
  principal_id         = var.azure_object_id
  role_definition_name = "DNS Zone Contributor"
  scope                = each.value.id
}