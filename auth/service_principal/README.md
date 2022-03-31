# Service Principal

Using a service principal to authenticate is the most common way to run Packer in production. It is also the easiest way to use Packer in Cloud Shell.

The remainder of the examples in this report will use service principal authentication as the default.

Protect the credentials! The client_secret or password should be considered a sensitive value.

## Creating a Service Principal

The default role to use with a Packer service principal is Contributor. Decide which scopes will be used for the role assignment.

The default (and recommended) Packer behaviour is to create a temporary resource group for the image build process. Assign the service principal Contributor access at the subscription scope as per *option 1*. Ideal when dedicating a subscription to images in larger estates.

A more granular approach is to follow *option 2* and limit the Contributor access to specific resource groups. You need to create a dedicated build resource group for this approach.

1. Get the resource ID for the scopes

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

## Packer

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
