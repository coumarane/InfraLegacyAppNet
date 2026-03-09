# Legacy application net 3.5

## Terraform Repository Structure

```
terraform/
│
├── global
│   ├── provider.tf
│   ├── versions.tf
│   ├── backend.tf
│
├── environments
│   ├── dev
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── terraform.tfvars
│   │   └── outputs.tf
│   │
│   └── prod
│       ├── main.tf
│       ├── variables.tf
│       ├── terraform.tfvars
│       └── outputs.tf
│
├── modules
│   ├── resource_group
│   │   └── main.tf
│   │
│   ├── network
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── subnet
│   │   └── main.tf
│   │
│   ├── nsg
│   │   └── main.tf
│   │
│   ├── keyvault
│   │   └── main.tf
│   │
│   ├── storage
│   │   └── main.tf
│   │
│   ├── vm_windows
│   │   └── main.tf
│   │
│   └── log_analytics
│       └── main.tf
│
└── README.md

```

## Usage

From the repo root:

Create tfvars in environments/dev or prod and call it dev.tfvars for dev, and add these values:
```bash
location          = "westeurope"
environment       = "dev"
project_name      = "legacyapp"
vm_admin_username = "azureadmin"
vm_admin_password = "MyPassword123!"
```

```bash
cp global/*.tf environments/dev/
cp global/*.tf environments/prod/

cd terraform/environments/dev
terraform init
terraform validate
terraform plan -var-file="dev.tfvars"
# terraform apply -var-file="dev.tfvars"
```