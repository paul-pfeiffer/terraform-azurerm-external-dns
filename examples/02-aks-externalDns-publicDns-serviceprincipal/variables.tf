variable "location" {
  description = "Location where resources should be created"
  type        = string
}

variable "tags" {
  description = "any tags that should be created on the resources"
  type        = map(string)
}

variable "dns_zone_resource_group_name" {
  type = string
}

variable "dns_zone_name" {
  type = string
}