# Azure CLI Token

These files can be run from your personal environment (Bash or PowerShell) and will use the Azure CLI token in ~/.azure.

Suitable for rapid testing of build scripts, but it is not for suited to production builds due to the dependency on a pre-existing and unexpired token. Does not work in Cloud Shell.

```shell
packer build ~/packer/auth/azure_cli_token/ubuntu_focal_gen2.pkr.hcl
```

Creates image *ubuntu_focal_gen2* in resource group *images*.

```shell
imageId=$(az image show --name ubuntu_focal_gen2 --resource-group images --query id --output tsv)
