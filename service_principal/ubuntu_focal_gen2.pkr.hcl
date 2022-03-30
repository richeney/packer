locals {
  managed_image_resource_group_name = length(var.managed_image_resource_group_name) > 0 ? var.managed_image_resource_group_name : "images"
}

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
    "file"   = "service_principal/ubuntu_focal_gen2.hcl"
  }

  build_resource_group_name         = var.build_resource_group_name
  managed_image_resource_group_name = var.managed_image_resource_group_name
  managed_image_name                = "ubuntu_focal_gen2"
}

build {
  sources = ["source.azure-arm.ubuntu_focal_gen2"]

  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"
    inline = [
      "apt-get update",
      "apt-get upgrade -y",
      "apt-get -y install jq tree stress",
      "echo export JQ_COLORS='1;90:1;35:1;35:0;36:0;33:1;37:1;37' >> /etc/skel/.bashrc",

      "/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync"
    ]

    inline_shebang = "/bin/sh -x"
  }
}
