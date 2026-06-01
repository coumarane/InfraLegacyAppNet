# Terraform Deployment Workflow Setup

This guide walks you through setting up the GitHub Actions workflows for deploying Terraform infrastructure on Azure.

## Prerequisites

1. **Azure Subscription** with appropriate permissions
2. **GitHub Repository** with Actions enabled
3. **Terraform State Storage** (Azure Storage Account or similar)
4. **Service Principal** for Azure authentication

## Step 1: Create an Azure Service Principal

Run these commands in Azure CLI or PowerShell:

```bash
# Create a Service Principal
az ad sp create-for-rbac --name "terraform-deployment" \
  --role Contributor \
  --scopes /subscriptions/{SUBSCRIPTION_ID}
```

This will output:
```json
{
  "appId": "CLIENT_ID",
  "displayName": "terraform-deployment",
  "password": "CLIENT_SECRET",
  "tenant": "TENANT_ID"
}
```

Also get your subscription ID:
```bash
az account show --query id --output tsv
```

## Step 2: Configure GitHub Secrets

Go to your GitHub repository → **Settings → Secrets and variables → Actions** and add these secrets:

| Secret Name | Value |
|---|---|
| `ARM_CLIENT_ID` | appId from Service Principal |
| `ARM_CLIENT_SECRET` | password from Service Principal |
| `ARM_SUBSCRIPTION_ID` | Your Azure Subscription ID |
| `ARM_TENANT_ID` | tenant from Service Principal |

## Step 3: Configure GitHub Environments

Go to **Settings → Environments** and create two environments:

### Environment 1: `prod-approve`
- **Environment name:** `prod-approve`
- **Protection rules:**
  - ✅ Enable "Required reviewers"
  - Add users who must approve prod deployments
  - Recommended: At least 1 reviewer

### Environment 2: `destroy-prod` (Optional)
- **Environment name:** `destroy-prod`
- **Protection rules:**
  - ✅ Enable "Required reviewers"
  - Add senior infrastructure team members

### Environment 3: `destroy-dev` (Optional)
- **Environment name:** `destroy-dev`
- **Protection rules:** Minimal (allows any team member)

## Step 4: Prepare Terraform Variable Files

Ensure you have `tfvars` files for each environment:

```
terraform/
├── environments/
│   ├── dev/
│   │   ├── dev.tfvars          ← Add variable values
│   │   └── dev.backend.hcl
│   └── prod/
│       ├── prod.tfvars          ← Add variable values
│       └── prod.backend.hcl
```

Example `dev.tfvars`:
```hcl
environment = "dev"
location    = "East US"
tags = {
  Environment = "Development"
  ManagedBy   = "Terraform"
  CostCenter  = "Engineering"
}
```

## Step 5: Configure Terraform Backend

Ensure your backend configurations point to your Azure Storage Account:

Example `terraform/environments/dev/dev.backend.hcl`:
```hcl
resource_group_name  = "rg-terraform-state"
storage_account_name = "tfstate{unique_suffix}"
container_name       = "dev"
key                  = "terraform.tfstate"
```

## Workflow Triggers

### Automatic Deployments (terraform-deploy.yml)
- **Triggers on:** Push to `main` branch (changes in `terraform/` directory)
- **Dev:** Auto-applies after plan succeeds
- **Prod:** Requires manual approval from reviewers

### Manual Destroy (terraform-destroy.yml)
- **Triggers:** Workflow dispatch (manual trigger from Actions tab)
- **Options:** Select environment (dev or prod)
- **Protection:** Prod requires approval, Dev is immediate

### Pull Request Validation (terraform-validate-pr.yml)
- **Triggers:** Pull requests affecting `terraform/` directory
- **Checks:** Format, validation, and TFLint
- **Comments:** Results posted to PR automatically

## Workflow Files

| Workflow | Purpose | Trigger |
|---|---|---|
| `terraform-deploy.yml` | Plan and apply infrastructure | Push to main |
| `terraform-destroy.yml` | Destroy infrastructure (manual) | Workflow dispatch |
| `terraform-validate-pr.yml` | Validate changes in PR | Pull request |

## Monitoring Deployments

1. Go to **Actions** tab in your repository
2. View workflow runs and job logs
3. For prod deployments, navigate to the `approve-prod` job to review the plan and approve
4. Check **Deployments** tab to see deployment history and approvals

## Troubleshooting

### Authentication Errors
- Verify all four secrets are correctly set
- Check Service Principal has sufficient permissions
- Confirm tenant ID and subscription ID are correct

### Terraform State Errors
- Verify backend storage account exists and is accessible
- Check backend configuration paths match environment names
- Ensure the service principal has Storage Blob Data Contributor role

### Plan Differences Between Local and CI
- Ensure local and CI use same Terraform version
- Use `terraform fmt` before committing
- Remove any local `.terraform` directory

### Missing Variables
- Verify `.tfvars` files exist for each environment
- Check variable names match between files and modules
- Review `terraform plan` output for missing values

## Security Best Practices

1. **Never hardcode secrets** - Always use GitHub Secrets
2. **Use Service Principal** - Avoid personal account authentication
3. **Approval gates on prod** - Require review before production changes
4. **State file security** - Secure remote backend and use encryption
5. **RBAC** - Limit Service Principal to required permissions
6. **Regular audits** - Review access logs and approvals regularly
7. **Secrets rotation** - Regenerate Service Principal credentials periodically

## Customization

### Change Terraform Version
Edit workflow files and update `TF_VERSION` environment variable:
```yaml
env:
  TF_VERSION: '1.6.0'  # Update this
```

### Add More Environments
1. Create new environment directory: `terraform/environments/staging/`
2. Add backend and tfvars files
3. Duplicate prod sections in workflow and rename/configure for new environment

### Custom Approval Strategy
Modify `approve-prod` job to include environment-specific requirements in GitHub settings.

## Additional Resources

- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Securing GitHub Actions](https://docs.github.com/en/actions/security-guides)
- [Azure CLI Reference](https://learn.microsoft.com/en-us/cli/azure/reference-index)
