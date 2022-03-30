source "azure-arm" "ubuntu_focal_gen2" {
  use_azure_cli_auth = true

  os_type = "Linux"
  image_publisher = "Canonical"
  image_offer = "0001-com-ubuntu-server-focal"
  image_sku = "20_04-lts-gen2"

  location = "UK South"
  vm_size = "Standard_B2s"

  azure_tags = {
    "source" = "Packer"
    "file" = "azure_cli_token/ubuntu_focal_gen2.pkr.hcl"
  }

  managed_image_resource_group_name = "images"
  managed_image_name = "ubuntu_focal_gen2"
}

build {
  sources = ["source.azure-arm.ubuntu_focal_gen2"]

  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"
    inline = [
      "apt-get update",
      "apt-get upgrade -y",
      "apt-get -y install jq tree stress",
      "echo export JQ_COLORS=\\\"1;90:1;35:1;35:0;36:0;33:1;37:1;37\\\" >> /etc/skel/.bashrc",

      "/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync"
    ]

    inline_shebang = "/bin/sh -x"
  }
}
