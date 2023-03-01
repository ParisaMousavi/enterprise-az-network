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

output "resourcegroup" {
  value = {
    name = module.resourcegroup.name
    id   = module.resourcegroup.id
  }
}
