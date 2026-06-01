# Terraform Deployment Quick Reference

## Workflow Overview

```
┌─────────────────┐
│   Git Push      │
│   to main       │
└────────┬────────┘
         │
    ┌────▼────┐
    │ Plan Dev │
    └────┬────┘
         │
    ┌────▼──────┐
    │ Apply Dev │ (Auto)
    └────┬──────┘
         │
    ┌────▼─────────┐
    │ Plan Prod     │
    └────┬──────────┘
         │
    ┌────▼──────────────┐
    │ Approve Prod      │ (Manual approval required)
    └────┬───────────────┘
         │
    ┌────▼──────────┐
    │ Apply Prod    │
    └───────────────┘
```

## Quick Start

### 1. Initial Setup (One-time)
```bash
# 1. Create Azure Service Principal
az ad sp create-for-rbac --name "terraform-deployment" --role Contributor --scopes /subscriptions/{SUBSCRIPTION_ID}

# 2. Add secrets to GitHub (Settings > Secrets and variables > Actions)
#    - ARM_CLIENT_ID
#    - ARM_CLIENT_SECRET
#    - ARM_SUBSCRIPTION_ID
#    - ARM_TENANT_ID

# 3. Create GitHub environments (Settings > Environments)
#    - prod-approve (with required reviewers)

# 4. Configure backend storage in Azure (optional but recommended)
```

### 2. Deploy Infrastructure

**To Dev (Automatic on push):**
```bash
git push origin main  # Automatically plans and applies to dev
```

**To Prod (With approval):**
- Push to main (triggers plan)
- Go to GitHub **Actions** tab
- Click on the workflow run
- Review the plan in the `plan-prod` job
- Click **Approve and deploy** on the `approve-prod` job
- Prod deployment proceeds automatically

### 3. Manual Operations

**To destroy an environment (manual):**
1. Go to GitHub **Actions** tab
2. Select **Terraform Destroy** workflow
3. Click **Run workflow**
4. Select environment: `dev` or `prod`
5. Confirm approval (if applicable)

**To run validation on a PR:**
- Create a pull request with terraform changes
- Validation runs automatically
- Results appear as a comment on the PR

## Workflow Files Created

| File | Purpose |
|------|---------|
| `.github/workflows/terraform-deploy.yml` | Main deployment workflow (push → plan → apply) |
| `.github/workflows/terraform-destroy.yml` | Manual destroy workflow |
| `.github/workflows/terraform-validate-pr.yml` | PR validation with format, lint checks |
| `.github/DEPLOYMENT_SETUP.md` | Detailed setup instructions |

## Environment Variables in Workflows

- `TF_VERSION` - Terraform version to use (currently 1.5.0)
- `WORKING_DIR` - Terraform directory path (./terraform)
- `ARM_*` - Azure authentication secrets (set in GitHub)

## Key Features

✅ **Dev Auto-Deploy** - Changes to terraform/ on main branch auto-deploy to dev
✅ **Prod Approval** - Production requires manual review and approval
✅ **PR Validation** - Pull requests automatically validated before merge
✅ **Plan Artifacts** - Plans stored for audit trail (5 days retention)
✅ **Format Checking** - Ensures terraform fmt compliance
✅ **Lint Checks** - TFLint validates best practices
✅ **Separate States** - Dev and prod have independent state files
✅ **Manual Destroy** - Destructive operations require explicit trigger

## Monitoring & Debugging

**View workflow runs:**
- GitHub repository → Actions tab

**View detailed logs:**
- Click on workflow run → Click job → View step logs

**Common issues:**
- Secret not found → Check spelling in GitHub Secrets
- Backend error → Verify storage account and credentials
- Plan failure → Check terraform/ changes and variable files
- Apply failure → Review logs and manual fixes might be needed

## Approval Process for Prod

1. Developer pushes to main
2. Workflow auto-plans both dev and prod
3. In GitHub Actions, click the workflow run
4. Scroll to `approve-prod` job
5. Review the `plan-prod` output for changes
6. Click **Review deployments**
7. Select `prod-approve` environment
8. Click **Approve and deploy**
9. Prod apply runs automatically

## Secrets Management

All Azure credentials are stored as GitHub Secrets:
- Never commit secrets to the repository
- Rotate credentials periodically
- Use least-privilege Service Principal role
- Audit secret access in GitHub logs

## Customization

To add a new environment (e.g., staging):

1. Create terraform environment:
   ```
   terraform/environments/staging/
   ├── staging.backend.hcl
   ├── staging.tfvars
   ├── main.tf
   ├── variables.tf
   ├── outputs.tf
   └── provider.tf
   ```

2. Duplicate prod sections in workflow files and rename

3. Create GitHub environment with appropriate approvers

## Need Help?

- Check `.github/DEPLOYMENT_SETUP.md` for detailed setup
- Review GitHub Actions logs for specific errors
- Verify Service Principal permissions in Azure
- Ensure terraform state backend is accessible
