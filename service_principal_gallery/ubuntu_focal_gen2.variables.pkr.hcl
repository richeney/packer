variable "tenant_id" {
  type    = string
  description = "The GUID for the tenant ID. Derived from subscription_id if unset."
  default = null
}

variable "client_id" {
  type    = string
  description = "The application ID for the service principal."
}

variable "client_secret" {
  type    = string
  description = "The password for the service principal."
  sensitive = true
}

variable "subscription_id" {
  type    = string
  description = "The subscription GUID."
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


variable "azure_compute_gallery" {
  type = object({
    subscription         = string
    resource_group       = string
    gallery_name         = string
    image_name           = string
    image_version        = string
    replication_regions  = list(string)
    storage_account_type = string
  })

  description = "Object describing the Azure Compute Gallery to publish the final image."

  default = {
    subscription         = null
    resource_group       = "gallery"
    gallery_name         = "gallery"
    image_name           = "ubuntu_focal_gen2"
    image_version        = "1.0.0"
    replication_regions  = ["UK South", "UK West"]
    storage_account_type = "Standard_LRS"
  }
}