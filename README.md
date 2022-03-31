# Packer

Set of reference files for Packer on Azure. Packer is commonly used to generate custom virtual machine images.

Images may be standalone resources, or versioned images stored in an Azure Compute Gallery (formerly known as Shared Image Gallery).

## Authentication

There are a few ways to authenticate to Azure when running Packer build and these examples show the difference and when each is commonly used.

| Authentication Type | Description |
|---|---|
| [interactive](auth/auth/interactive/README.md) | Interactive login |
| [azure_cli_token](auth/auth/azure_cli_token/README.md) | Manually test image builds from your local system |
| [managed_identity](auth/managed_identity/README.md) | As above, but run on a config management server or in Cloud Shell |
| [service_principal](auth/service_principal/README.md) | Suitable for production image creation CI/CD pipelines |

All of the examples above will create the same Ubuntu 20.04 custom image.

## Scenarios

Examples of additional scenarios. All of the examples below authenticate using service principal variables.

| Scenario | Description |
|---|---|
| [service_principal_gallery](service_principal_gallery/README.md) | As above, with additional Azure Compute Gallery publishing step |

More to be added, e.g. custom image to custom image, custom image to gallery image, gallery image to gallery image, cloud-init, Ansible, etc.

> Raise an issue if there is a specific scenario that you would like to see.

## Setup

### Packer directory

Clone this repo so that you have the example files locally.

1. Clone the repo

    The lab assumes you are in your home directory. (`cd ~`)

    ```shell
    git clone https://github.com/richeney/packer
    ```

1. Change directory

    ```shell
    cd packer
    ```

1. Set local defaults

    Setting local defaults will save typing `--location <region>` for each command. Set to your preferred location.

    ```shell
    az config set --local defaults.location=uksouth
    ```

    > The examples use UK South as the primary region. Images are replicated to UK West.

### Managed image resource group

Creating custom images with Packer requires an existing resource group for the resulting custom images.

You will need an resource group for your images.

```shell
az group create --name images
```

> You can use a different name but you will have to edit the value for *managed_image_resource_group_name* in the files.

### Build resource group

*Optional.*

Packer will create temporary resource groups for build artefacts if it has sufficient access. Therefore this resource group is only required if you a) you are using service principals and b) you need to be more selective with the the assigned access. See [service principal](auth/service_principal/README.md) for more info.

```shell
az group create --name packer
```

> You can use a different name but you will have to edit the value for *build_resource_group_name* in the files.

### Azure Compute Gallery

Run the following commands if you are using the Azure Compute Gallery examples.

1. Create the gallery resource group

    ```shell
    az group create --name gallery
    ```

1. Create the Azure Compute Gallery

    ```shell
    az sig create --gallery-name gallery --resource-group gallery
    ```

1. Get the resource ID

    ```shell
    galleryId=$(az sig show --gallery-name $gallery --resource-group gallery --query id --output tsv)
    ```

## Links

* <https://www.packer.io/plugins/builders/azure>
* <https://www.packer.io/plugins/builders/azure/arm>
* <https://github.com/hashicorp/packer-plugin-azure/tree/main/example>