data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "this" {
  name                            = var.name
  location                        = var.location
  resource_group_name             = var.resource_group_name
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  sku_name                        = var.sku_name
  soft_delete_retention_days      = var.soft_delete_retention_days
  purge_protection_enabled        = var.purge_protection_enabled
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment
  public_network_access_enabled   = var.public_network_access_enabled

  tags = var.tags
}

resource "azurerm_role_assignment" "kv_admin" {
  count = var.kv_admin_principal_id != null ? 1 : 0

  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = var.kv_admin_principal_id
}
