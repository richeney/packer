# Interactive

Set the value of `subscription_id = "your_subscription_id"` to your subscription ID as shown by `az account show --query id --output tsv`.

The interactive mode goes through the standard authentication process and stores a token in `~/.azure/packer`.

Suitable for rapid testing of build scripts, but it is not for suited to production builds due to the interactive step. Does not work in Cloud Shell.

```shell
packer build ~/packer/auth/interactive/ubuntu_focal_gen2.pkr.hcl
```

Creates image *ubuntu_focal_gen2* in resource group *images*.

```shell
imageId=$(az image show --name ubuntu_focal_gen2 --resource-group images --query id --output tsv)
