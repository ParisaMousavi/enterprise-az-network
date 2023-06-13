locals {
  azurecr_private_dns_zone_name     = "privatelink.azurecr.io"
  vaultcore_private_dns_zone_name   = "privatelink.vaultcore.azure.net"
  website_private_dns_zone_name     = "privatelink.azurewebsites.net"
  scm_website_private_dns_zone_name = "scm.privatelink.azurewebsites.net"
}

resource "azurerm_private_dns_zone" "this_azurecr" {
  name                = local.azurecr_private_dns_zone_name
  resource_group_name = module.resourcegroup.name
  tags = {
    CostCenter = "ABC000CBA"
    By         = "parisamoosavinezhad@hotmail.com"
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "this_azurecr" {
  name                  = "${module.network.name}-vnet2dns"
  resource_group_name   = module.resourcegroup.name
  private_dns_zone_name = azurerm_private_dns_zone.this_azurecr.name
  virtual_network_id    = module.network.id
}

# https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-dns#azure-services-dns-zone-configuration
resource "azurerm_private_dns_zone" "this_vaultcore" {
  name                = local.vaultcore_private_dns_zone_name
  resource_group_name = module.resourcegroup.name
  tags = {
    CostCenter = "ABC000CBA"
    By         = "parisamoosavinezhad@hotmail.com"
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "this_vaultcore" {
  name                  = "${module.network.name}-vnet2dns"
  resource_group_name   = module.resourcegroup.name
  private_dns_zone_name = azurerm_private_dns_zone.this_vaultcore.name
  virtual_network_id    = module.network.id
}

#-------------------------------------------
# for web app
#-------------------------------------------
resource "azurerm_private_dns_zone" "this_website" {
  name                = local.website_private_dns_zone_name
  resource_group_name = module.resourcegroup.name
  tags = {
    CostCenter = "ABC000CBA"
    By         = "parisamoosavinezhad@hotmail.com"
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "this_website" {
  name                  = "${module.network.name}-vnet2dns"
  resource_group_name   = module.resourcegroup.name
  private_dns_zone_name = azurerm_private_dns_zone.this_website.name
  virtual_network_id    = module.network.id
}

resource "azurerm_private_dns_zone" "this_website_scm" {
  name                = local.scm_website_private_dns_zone_name
  resource_group_name = module.resourcegroup.name
  tags = {
    CostCenter = "ABC000CBA"
    By         = "parisamoosavinezhad@hotmail.com"
  }
}

resource "azurerm_private_dns_zone_virtual_network_link" "this_website_scm" {
  name                  = "${module.network.name}-vnet2dns"
  resource_group_name   = module.resourcegroup.name
  private_dns_zone_name = azurerm_private_dns_zone.this_website_scm.name
  virtual_network_id    = module.network.id
}