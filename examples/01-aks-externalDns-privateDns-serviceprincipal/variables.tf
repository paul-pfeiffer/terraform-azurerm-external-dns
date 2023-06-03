variable "location" {
  description = "Location where resources should be created"
  type = string
}

variable "tags" {
  description = "any tags that should be created on the resources"
  type = map(string)
}