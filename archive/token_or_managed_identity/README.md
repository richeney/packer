# Read Me

## Limitations

There is no support for Azure Key Vault except for certificates. (See <broken/std_key_vault.json>.)

## Resource Group

Create a resource group for the images:

```bash
az group create --name images --output jsonc
```

## std_token.json

The file requires a value for the subscription_id variable. (With a blank value it will try to use managed identity.) It will prompt you to logon interactively to generate mgmt and vault tokens. Once they exist then they will be reused automatically until they expire.

### Running Packer

Provide a value for the subscription_id variable when using this template:

```bash
subscription_id=$(az account show --output tsv --query id)
packer build -var subscription_id=$subscription_id std_token.json
```

## std_env_vars.json

Requires the following environment variables before building:

* ARM_TENANT_ID
* ARM_SUBSCRIPTION_ID
* ARM_CLIENT_ID
* ARM_CLIENT_SECRET

### Export the environment variables

Export the environment variables, setting the values as strings.

```bash
export ARM_TENANT_ID=<TENANT_ID>
export ARM_SUBSCRIPTION_ID=<SUBSCRIPTION_ID>
export ARM_CLIENT_ID=<CLIENT_ID>
export ARM_CLIENT_SECRET=<CLIENT_SECRET>
```

Or pull the values from a key vault or via CLI commands:

```bash
kv=terraformwlbepd40ne76h31 # Change to your keyvault name
export ARM_TENANT_ID=$(az account show --query tenant_id --output tsv)
export ARM_SUBSCRIPTION_ID=$(az account show --query id --output tsv)
export ARM_CLIENT_ID=$(az keyvault secret show --name client-id --vault-name=$kv --query value --output tsv)
export ARM_CLIENT_SECRET=$(az keyvault secret show --name client-secret --vault-name=$kv --query value --output tsv)
```

If you add the lines to your ~/.bashrc then run `source ~/.bashrc` to refresh the current shell.

### Running Packer

```bash
packer build std_env_vars.json
```
