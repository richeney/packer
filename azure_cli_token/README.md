# Azure CLI Token

These files can be run from your personal environment (Bash or PowerShell) and will use the Azure CLI token in ~/.azure.

Perfect for rapid testing of build scripts.

```shell
packer build ~/packer/azure_cli_token/ubuntu_focal_gen2.pkr.hcl
```

Creates image *ubuntu_focal_gen2* in resource group *images*.

```shell
imageId=$(az image show --name ubuntu_focal_gen2 --resource-group images --query id --output tsv)
