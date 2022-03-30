source "azure-arm" "ubuntu_focal_gen2" {
  tenant_id       = var.tenant_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  subscription_id = var.subscription_id

  os_type         = "Linux"
  image_publisher = "Canonical"
  image_offer     = "0001-com-ubuntu-server-focal"
  image_sku       = "20_04-lts-gen2"
  location        = var.build_resource_group_name == null ? var.location : null
  vm_size         = "Standard_B2s"

  azure_tags = {
    "source" = "Packer"
    "file"   = "service_principal_gallery/ubuntu_focal_gen2.hcl"
  }

  build_resource_group_name         = var.build_resource_group_name
  managed_image_resource_group_name = var.managed_image_resource_group_name
  managed_image_name                = "ubuntu_focal_gen2"

  shared_image_gallery_destination {
    subscription         = var.azure_compute_gallery.subscription
    resource_group       = var.azure_compute_gallery.resource_group
    gallery_name         = var.azure_compute_gallery.gallery_name
    image_name           = var.azure_compute_gallery.image_name
    image_version        = var.azure_compute_gallery.image_version
    replication_regions  = var.azure_compute_gallery.replication_regions
    storage_account_type = var.azure_compute_gallery.storage_account_type
  }
}
