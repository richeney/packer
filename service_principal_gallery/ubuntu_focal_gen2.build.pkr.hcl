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
