output "subnets" {
  value = module.network.subnets
}

output "network_id" {
  value = module.network.id

}

output "privatelink_azurecr_io" {
  value = {
    name = azurerm_private_dns_zone.this_azurecr.name
    id   = azurerm_private_dns_zone.this_azurecr.id
  }
}

output "privatelink_vaultcore_azure_net" {
  value = {
    name = azurerm_private_dns_zone.this_vaultcore.name
    id   = azurerm_private_dns_zone.this_vaultcore.id
  }
}

output "privatelink_azurewebsites_net" {
  value = {
    name = azurerm_private_dns_zone.this_website.name
    id   = azurerm_private_dns_zone.this_website.id
  }
}

output "privatelink_this_website_scm" {
  value = {
    name = azurerm_private_dns_zone.this_website_scm.name
    id   = azurerm_private_dns_zone.this_website_scm.id
  }
}

output "resourcegroup" {
  value = {
    name = module.resourcegroup.name
    id   = module.resourcegroup.id
  }
}

output "nsg_id" {
  value = module.nsg.id
}

output "nsg_win_id" {
  value = module.nsg_win.id
}