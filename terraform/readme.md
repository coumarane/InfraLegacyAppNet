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

```bash
az login
```

From the repo root:

- Create dev.tfvars in environments/dev for dev, and add these values:
```bash
subscription_id   = "12345"
location          = "westeurope"
environment       = "dev"
project_name      = "legacyapp"
vm_admin_username = "azureadmin"
vm_admin_password = "MyPassword123!"
```

Add in dev.backend.hcl:
```bash
resource_group_name  = "rg-terraform-dev"
storage_account_name = "terraformstatedev"
container_name       = "tfstatedev"
key                  = "dev.terraform.tfstate"
```

Run the code
```bash
cd terraform/environments/dev
terraform init -reconfigure -backend-config=dev.backend.hcl
terraform validate
terraform plan -var-file="dev.tfvars"
# terraform apply -var-file="dev.tfvars"
```

- For prod, create prod.tfvars in environments/prod for prod, and add these values:
```bash
subscription_id   = "6789"
location          = "westeurope"
environment       = "prod"
project_name      = "legacyapp"
vm_admin_username = "azureadmin"
vm_admin_password = "MyPassword123!"
```

Add in prod.backend.hcl:
```bash
resource_group_name  = "rg-terraform-prod"
storage_account_name = "terraformstateprod"
container_name       = "tfstateprod"
key                  = "prod.terraform.tfstate"
```

Run the code
```bash
cd terraform/environments/prod
terraform init
terraform validate
terraform plan -var-file="prod.tfvars"
# terraform apply -var-file="prod.tfvars"
```