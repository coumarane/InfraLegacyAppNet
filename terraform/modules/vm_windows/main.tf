resource "azurerm_public_ip" "this" {
  count = var.create_public_ip ? 1 : 0

  name                = "${var.name}-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = var.tags
}

resource "azurerm_network_interface" "this" {
  name                = "${var.name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.create_public_ip ? azurerm_public_ip.this[0].id : null
  }

  tags = var.tags
}

resource "azurerm_windows_virtual_machine" "this" {
  name                  = var.name
  computer_name         = var.computer_name != null ? var.computer_name : substr(replace(var.name, "-", ""), 0, 15)
  location              = var.location
  resource_group_name   = var.resource_group_name
  size                  = var.size
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  network_interface_ids = [azurerm_network_interface.this.id]

  provision_vm_agent         = true
  automatic_updates_enabled  = true
  patch_mode                 = "AutomaticByOS"
  encryption_at_host_enabled = var.encryption_at_host_enabled

  os_disk {
    name                 = "${var.name}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = var.os_disk_storage_account_type
  }

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.image_sku
    version   = var.image_version
  }

  identity {
    type = var.identity_type
  }

  tags = var.tags
}

resource "azurerm_virtual_machine_extension" "bootstrap" {
  count = var.bootstrap_command != "" ? 1 : 0

  name                       = "${var.name}-bootstrap"
  virtual_machine_id         = azurerm_windows_virtual_machine.this.id
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.10"
  # CustomScriptExtension does not support automatic upgrades
  automatic_upgrade_enabled  = false
  auto_upgrade_minor_version = true

  settings = jsonencode({
    fileUris = var.bootstrap_file_uris
  })

  protected_settings = jsonencode({
    commandToExecute = var.bootstrap_command
  })
}
