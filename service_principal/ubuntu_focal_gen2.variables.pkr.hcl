variable "tenant_id" {
  type    = string
  description = "The GUID for the tenant ID. Derived from subscription_id if unset."
  default = null
}

variable "client_id" {
  type    = string
  description = "The application ID for the service principal."

  validation {
    condition     = length(var.client_id) > 0
    error_message = <<-EOF
      The client_id is not set. Use the appId of the service principal.
      Export as environment variable PKR_VAR_client_id or set the client_id variable.
    EOF
  }
}

variable "client_secret" {
  type    = string
  description = "The password for the service principal."
  sensitive = true

  validation {
    condition     = length(var.client_secret) > 0
    error_message = <<-EOF
      The client_secret is not set. Use the password of the service principal.
      Export as environment variable PKR_VAR_client_secret or set the client_secret variable.
    EOF
  }
}

variable "subscription_id" {
  type    = string
  description = "The subscription GUID."

  validation {
    condition     = length(var.subscription_id) > 0
    error_message = <<-EOF
      The subscription_id is not set.
      Export as environment variable PKR_VAR_subscription_id or set the subscription_id variable.
    EOF
  }
}

variable "managed_image_resource_group_name" {
  description = "The resource group for the finished managed image. Defaults to images."
  type    = string
  default = "images"
}

variable "build_resource_group_name" {
  description = "Pre-existing resource group for the temporary build resources. Defaults to system generated - needs Contributor at subscription scope."

  type    = string
  default = null
}

variable "location" {
  description = "Azure region for the temporary build resources. Defaults to UK South."

  type    = string
  default = "UK South"
}
