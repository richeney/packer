# Managed Identity

These files are very similar to the Managed Identity and show the difference in authentication. (Only difference is that the `use_azure_cli_auth = true` is omitted.)

These require a managed identity (system or user assigned) on a server (e.g. a config management server) which has Contributor access on the subscription, or on specific resource groups.



```shell
packer build ~/packer/auth/managed_identity/ubuntu_focal_gen2.pkr.hcl
```

Creates image *ubuntu_focal_gen2* in resource group *images*.

```shell
imageId=$(az image show --name ubuntu_focal_gen2 --resource-group images --query id --output tsv)
