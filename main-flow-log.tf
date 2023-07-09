
# module "log_flow_storage_name" {
#   source   = "github.com/ParisaMousavi/az-naming//st?ref=main"
#   prefix   = var.prefix
#   name     = var.name
#   stage    = var.stage
#   assembly = "logf"
#   # location_shortname = var.location_shortname
# }


# #------------------------------------------------------
# # Flow log's Storage and NSG must be in the same region
# #------------------------------------------------------
# module "log_flow_storage" {
#   count                           = var.with_watcher == true ? 1 : 0
#   source                          = "github.com/ParisaMousavi/az-storage-account?ref=main"
#   name                            = module.log_flow_storage_name.result
#   location                        = module.resourcegroup.location
#   resource_group_name             = module.resourcegroup.name
#   account_kind                    = "StorageV2"
#   account_tier                    = "Standard"
#   objectreplication               = false
#   service_endpoint_subnet_ids     = []
#   pe_subresources                 = []
#   private_dns_zone_ids            = {}
#   subnet_id                       = null
#   azure_service_bypass            = true
#   ip_rules                        = []
#   log_analytics_workspace_id      = null
#   eventhub_name                   = null
#   eventhub_namespace_auth_rule_id = null
#   additional_tags = {
#     CostCenter = "ABC000CBA"
#     By         = "parisamoosavinezhad@hotmail.com"
#     Dataclass  = ""
#   }
# }


# module "log_flow_name" {
#   source             = "github.com/ParisaMousavi/az-naming//flow-logs?ref=main"
#   prefix             = var.prefix
#   name               = var.name
#   stage              = var.stage
#   assembly           = "nsg"
#   location_shortname = var.location_shortname
# }

# module "log_flow_nsg" {
#   count                     = var.with_watcher == true ? 1 : 0
#   source                    = "github.com/ParisaMousavi/az-nsg-flow-logs?ref=main"
#   name                      = module.log_flow_name.result
#   location                  = module.resourcegroup.location
#   resource_group_name       = module.resourcegroup.name
#   network_watcher_name      = module.watcher[0].name
#   network_security_group_id = module.nsg.id
#   storage_account_id        = module.log_flow_storage[0].id
#   additional_tags = {
#     CostCenter = "ABC000CBA"
#     By         = "parisamoosavinezhad@hotmail.com"
#   }
# }

# module "log_flow_nsg_win_name" {
#   source             = "github.com/ParisaMousavi/az-naming//flow-logs?ref=main"
#   prefix             = var.prefix
#   name               = var.name
#   stage              = var.stage
#   assembly           = "nsg_win"
#   location_shortname = var.location_shortname
# }

# module "log_flow_nsg_win" {
#   count                     = var.with_watcher == true ? 1 : 0
#   source                    = "github.com/ParisaMousavi/az-nsg-flow-logs?ref=main"
#   name                      = module.log_flow_nsg_win_name.result
#   location                  = module.resourcegroup.location
#   resource_group_name       = module.resourcegroup.name
#   network_watcher_name      = module.watcher[0].name
#   network_security_group_id = module.nsg_win.id
#   storage_account_id        = module.log_flow_storage[0].id
#   additional_tags = {
#     CostCenter = "ABC000CBA"
#     By         = "parisamoosavinezhad@hotmail.com"
#   }
# }