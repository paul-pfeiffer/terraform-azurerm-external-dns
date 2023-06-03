variable "azure_client_id" {
  type = string
}

variable "azure_object_id" {
  type = string
}

variable "azure_tenant_id" {
  type = string
}

variable "azure_client_secret" {
  type = string
}

variable "azure_subscription_id" {
  type = string
}

variable "resource_group_name" {
  description = "resource group that contain the dns zones"
  type        = string
}

variable "set_permission" {
  description = "If set to true, the reader permission on the dns resource group as well as the private DNS Zone Contributor permission are set"
  type        = bool
}

variable "domain_filters" {
  type = list(string)
}

variable "dns_provider" {
  default = "azure-private-dns"
  validation {
    condition     = var.dns_provider == "azure-private-dns" || var.dns_provider == "azure"
    error_message = "Currently only azure-private-dns and azure is supported"
  }
}