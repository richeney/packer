# Service Principal

See the main [README.md](../README.md) for details on creating and using service principals.

This example uses multiple HCL files. Specify the directory rather than a single file.

```shell
packer build ~/packer/service_principal_gallery
```

or (if in the directory)

```shell
packer build .
```

Creates image *ubuntu_focal_gen2* in resource group *images*.

```shell
imageId=$(az image show --name ubuntu_focal_gen2 --resource-group images --query id --output tsv)
