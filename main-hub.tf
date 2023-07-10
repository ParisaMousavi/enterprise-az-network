#----------------------------------------------
#       Enterprise Network Hub
#----------------------------------------------
module "network_hub_name" {
  source             = "github.com/ParisaMousavi/az-naming//vnet?ref=main"
  prefix             = var.prefix
  stage              = "${var.stage}-hub"
  location_shortname = var.location_shortname
}

module "network_hub" {
  count                      = var.with_hub == true ? 1 : 0
  source                     = "github.com/ParisaMousavi/az-vnet-v2?ref=main"
  name                       = module.network_hub_name.result
  location                   = module.resourcegroup.location
  resource_group_name        = module.resourcegroup.name
  address_space              = local.projn_hub.address_space
  dns_servers                = local.projn_hub.dns_servers
  subnets                    = local.projn_hub.subnets
  log_analytics_workspace_id = var.with_monitor == true ? data.terraform_remote_state.monitoring.outputs.log_analytics_workspace_id : null
  additional_tags = {
    CostCenter = "ABC000CBA"
    By         = "parisamoosavinezhad@hotmail.com"
  }
}
