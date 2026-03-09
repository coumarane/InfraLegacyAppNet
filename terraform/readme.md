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

```bash
cp global/*.tf environments/dev/
cd environments/dev
terraform init
terraform plan
terraform apply