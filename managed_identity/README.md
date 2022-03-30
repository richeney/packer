# Managed Identity

These files are very similar to the Managed Identity and show the difference in authentication. (Only difference is that the `use_azure_cli_auth = true` is omitted.)

These can be run from Cloud Shell (which uses a managed identity on the linux container) or from a config management server which has a managed identity with Contributor access.

```shell
packer build ~/packer/managed_identity/ubuntu_focal_gen2.pkr.hcl
```

Creates image *ubuntu_focal_gen2* in resource group *images*.

```shell
imageId=$(az image show --name ubuntu_focal_gen2 --resource-group images --query id --output tsv)
