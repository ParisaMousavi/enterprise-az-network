
module "log_flow_name" {
  source             = "github.com/ParisaMousavi/az-naming//nw?ref=main"
  prefix             = var.prefix
  name               = var.name
  stage              = var.stage
  location_shortname = var.location_shortname
}

module "log_flow" {
  count                     = var.with_watcher == true ? 1 : 0
  source                    = "github.com/ParisaMousavi/az-nsg-flow-logs?ref=main"
  name                      = module.log_flow_name.result
  location                  = module.resourcegroup.location
  resource_group_name       = module.resourcegroup.name
  network_watcher_name      = module.watcher[0].name
  network_security_group_id = module.nsg.id
  storage_account_id        = "/subscriptions/e75710b2-d656-4ee7-bc64-d1b371656208/resourceGroups/netexc-rg-projn-dev-network-weu/providers/Microsoft.Storage/storageAccounts/netexcprojndeweu"
  additional_tags = {
    CostCenter = "ABC000CBA"
    By         = "parisamoosavinezhad@hotmail.com"
  }
}
