output "resource_group_name" {
  value = module.resource_group.name
}

output "vnet_name" {
  value = module.network.name
}

output "subnet_id" {
  value = module.subnet_app.id
}

output "log_analytics_workspace_id" {
  value = module.log_analytics.workspace_id
}

output "key_vault_name" {
  value = module.keyvault.name
}

output "storage_account_name" {
  value = module.storage.name
}

output "vm_name" {
  value = module.vm_windows.name
}

output "vm_private_ip" {
  value = module.vm_windows.private_ip_address
}
