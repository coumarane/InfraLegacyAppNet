locals {
  common_tags = {
    environment = var.environment
    project     = var.project_name
    managed_by  = "terraform"
  }

  rg_name     = "rg-${var.environment}-${var.project_name}"
  vnet_name   = "vnet-${var.environment}-${var.project_name}"
  subnet_name = "snet-app"
  nsg_name    = "nsg-${var.environment}-${var.project_name}"
  log_name    = "log-${var.environment}-${var.project_name}"
  kv_name     = "kv${var.environment}${var.project_name}01"
  st_name     = "st${var.environment}${var.project_name}01"
  vm_name     = "vm-${var.environment}-${var.project_name}-01"
}

module "resource_group" {
  source = "../../modules/resource_group"

  name     = local.rg_name
  location = var.location
  tags     = local.common_tags
}

module "network" {
  source = "../../modules/network"

  vnet_name           = local.vnet_name
  resource_group_name = module.resource_group.name
  location            = var.location
  address_space       = ["10.10.0.0/16"]
  tags                = local.common_tags
}

module "subnet_app" {
  source = "../../modules/subnet"

  subnet_name         = local.subnet_name
  resource_group_name = module.resource_group.name
  vnet_name           = module.network.name
  address_prefixes    = ["10.10.1.0/24"]
}

module "nsg_app" {
  source = "../../modules/nsg"

  name                  = local.nsg_name
  location              = var.location
  resource_group_name   = module.resource_group.name
  subnet_id             = module.subnet_app.id
  associate_with_subnet = true
  tags                  = local.common_tags

  security_rules = [
    {
      name                       = "allow-rdp-from-corp"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_address_prefix      = "10.0.0.0/8"
      source_port_range          = "*"
      destination_address_prefix = "*"
      destination_port_range     = "3389"
      description                = "Allow RDP from corporate range"
    },
    {
      name                       = "allow-http"
      priority                   = 110
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_address_prefix      = "*"
      source_port_range          = "*"
      destination_address_prefix = "*"
      destination_port_range     = "80"
      description                = "Allow HTTP"
    },
    {
      name                       = "allow-https"
      priority                   = 120
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_address_prefix      = "*"
      source_port_range          = "*"
      destination_address_prefix = "*"
      destination_port_range     = "443"
      description                = "Allow HTTPS"
    }
  ]
}

module "log_analytics" {
  source = "../../modules/log_analytics"

  name                = local.log_name
  location            = var.location
  resource_group_name = module.resource_group.name
  retention_in_days   = 30
  tags                = local.common_tags
}

module "keyvault" {
  source = "../../modules/keyvault"

  name                          = local.kv_name
  location                      = var.location
  resource_group_name           = module.resource_group.name
  public_network_access_enabled = true
  purge_protection_enabled      = true
  tags                          = local.common_tags
}

module "storage" {
  source = "../../modules/storage"

  name                          = local.st_name
  location                      = var.location
  resource_group_name           = module.resource_group.name
  account_tier                  = "Standard"
  account_replication_type      = "LRS"
  account_kind                  = "StorageV2"
  access_tier                   = "Hot"
  public_network_access_enabled = true
  container_names               = ["app-data", "logs"]
  tags                          = local.common_tags
}

module "vm_windows" {
  source = "../../modules/vm_windows"

  name                = local.vm_name
  location            = var.location
  resource_group_name = module.resource_group.name
  subnet_id           = module.subnet_app.id
  admin_username      = var.vm_admin_username
  admin_password      = var.vm_admin_password
  create_public_ip    = false
  size                = "Standard_B2ms"
  tags                = local.common_tags
}
