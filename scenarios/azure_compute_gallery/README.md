# Service Principal Gallery

This example creates the image and then publishes to an Azure Compute Gallery (previously called Shared Image Gallery). Assumes all [setup](../../README.md#setup) steps are complete

1. Create the image definition

    Create image definition *ubuntu_focal_gen2* in Azure Compute Gallery *gallery*.

    ```shell
    az sig image-definition create --gallery-name gallery --gallery-image-definition ubuntu_focal_gen2 --publisher "AzureCitadel" --offer Ubuntu --sku 20.04 --os-type linux --hyper-v-generation V2 --resource-group gallery
    ```

1. Run the Packer build

    Fully pathed:

    ```shell
    packer build ~/packer/service_principal_gallery
    ```

    Or, if in the directory:

    ```shell
    packer build .
    ```

Also creates image *ubuntu_focal_gen2* in resource group *images*.

Publishes to image definition *ubuntu_focal_gen2* (v1.0.0) in Azure Compute Gallery *gallery* in the *gallery* resource group.

```shell
imageId=$(az sig image-definition show --gallery-name gallery --gallery-image-definition ubuntu_focal_gen2 --resource-group gallery --query id --output tsv)
```
