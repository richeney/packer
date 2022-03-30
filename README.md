# Packer

Set of reference files for Packer on Azure.

## Scenarios

| Directory | Scenario |
|---|---|
| [azure_cli_token](azure_cli_token/README.md) | Manually test image builds from your local system |
| [managed_identity](managed_identity/README.md) | As above, but run on a config management server or in Cloud Shell |
| [service_principal](service_principal/README.md) | Suitable for production image creation CI/CD pipelines |
| [service_principal_gallery](service_principal_gallery/README.md) | As above, with additional Azure Compute Gallery publishing step |

## Setup

### Initialise

1. Clone the repo

    The lab assumes you are in your home directory. (`cd ~`)

    ```shell
    git clone https://github.com/richeney/gallery
    ```

1. Change directory

    ```shell
    cd gallery
    ```

1. Set local defaults

    Setting local defaults will save typing `--location <region>` for each command. Set to your preferred location.

    ```shell
    az config set --local defaults.location=uksouth
    ```

    > The examples use UK South as the primary region. Images are replicated to UK West.

1. Create managed image resource group

    You will need an resource group for your images.

    ```shell
    az group create --name images
    ```

    > You can use a different name but you will have to edit the value for *managed_image_resource_group_name* in the files.

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

### Service Principal

Using a service principal to authenticate is the most common way to run Packer in production. Protect the credentials!

1. Get the resource ID for the scopes

    The service principal will use the Contributor role. You have a decision to make, to decide which scopes will be used for the role assignment.

    The default (and recommended) Packer behaviour is to create a temporary resource group for the image build process. This is *option 1* and the service principal would be given Contributor access at the subscription scope. (Consider dedicating a subscription to images in larger estates.)

    As an alternative, follow *option 2* to create a dedicated build resource group and limit the Contributor access to specific resource groups.

    * *Option 1*: Subscription scope

      ```shell
      scopes=$(az account show --query id --output tsv)
      ```

    * *Option 2*: Specific resource groups

      Create a dedicated resource group for Packer to use during the build process.

      ```shell
      az group create --name packer
      ```

      Grab the resource IDs.

      ```shell
      scopes=$(az group list --query "[?name == 'packer' || name == 'images' || name == 'gallery'].id" --output tsv)
      ```

1. Create the service principal

    The cosmetic name is optional. (Azure will system generate a name if omitted.)

    ```shell
    az ad sp create-for-rbac --name http://packer --role Contributor --scopes $scopes
    ```

    Capture the JSON output of this command for the next step. The password will not be shown again.

    > You can rerun the command and it will regenerate a new password.

## Specifying Service Principal credentials

Example output from `az ad sp create-for-rbac` commands.

```json
{
  "appId": "ae69ebd9-72c8-4238-a0ec-627b59172778",
  "displayName": "http://packer",
  "password": "EnZ-Zn0oqLRFX-5S4YYVq5zPSx1xR4Eoey",
  "tenant": "72f988bf-86f1-41af-91ab-2d7cd011db47"
}
```

The values map to the following commonly used Packer variables.

| Azure CLI command | JSON key | Packer variable |
|---|---|---|
| `az ad sp create-for-rbac` | `tenant` | `tenant_id` |
| | `appId` | `client_id` |
| | `password` | `client_secret` |
| `az account show` | `id` | `subscription_id` |

You have many choices when [assigning values to input variables](https://www.packer.io/docs/templates/hcl_templates/variables#assigning-values-to-build-variables). Most common are:

* [Environment variables](https://www.packer.io/docs/templates/hcl_templates/variables#environment-variables)

   `export PKR_VAR_client_secret="EnZ-Zn0oqLRFX-5S4YYVq5zPSx1xR4Eoey"`

   Most CI/CD pipelines - such as GitHub Actions or Azure DevOps pipelines - support environment variables natively.

* [Variable files](https://www.packer.io/docs/templates/hcl_templates/variables#variable-definitions-pkrvars-hcl-and-auto-pkrvars-hcl-files)

   Example testing.auto.pkvars.hcl file:

   ```go
   tenant_id       = "72f988bf-86f1-41af-91ab-2d7cd011db47"
   client_id       = "ae69ebd9-72c8-4238-a0ec-627b59172778"
   client_secret   = "EnZ-Zn0oqLRFX-5S4YYVq5zPSx1xR4Eoey"
   subscription_id = "2ca40be1-7e80-4f2b-92f7-06b2123a68cc"
   ```

> You may avoid using variables altogether and hardcode the values as strings in the templates. You will need to protect the files accordingly.

## Links

* <https://www.packer.io/plugins/builders/azure>
* <https://www.packer.io/plugins/builders/azure/arm>
* <https://github.com/hashicorp/packer-plugin-azure/tree/main/example>