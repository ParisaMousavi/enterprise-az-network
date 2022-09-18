locals {
  projn = jsondecode(file("${path.module}/config/${var.prefix}-${var.stage}-${var.location_shortname}.json"))
}

module "rg_name" {
  source             = "git::https://eh4amjsb2v7ke7yzqzkviryninjny3urbbq3pbkor25hhdbo5kea@dev.azure.com/p-moosavinezhad/az-iac/_git/az-naming//rg?ref=main"
  prefix             = var.prefix
  name               = var.name
  stage              = var.stage
  location_shortname = var.location_shortname
}

module "resourcegroup" {
  # https://{PAT}@dev.azure.com/{organization}/{project}/_git/{repo-name}
  source   = "git::https://eh4amjsb2v7ke7yzqzkviryninjny3urbbq3pbkor25hhdbo5kea@dev.azure.com/p-moosavinezhad/az-iac/_git/az-resourcegroup?ref=main"
  location = var.location
  name     = module.rg_name.result
  tags = {
    Service         = "Plat. netexc"
    AssetName       = "Asset Name"
    AssetID         = "AB00CD"
    BusinessUnit    = "Plat. netexc Team"
    Confidentiality = "C1"
    Integrity       = "I1"
    Availability    = "A1"
    Criticality     = "Low"
    Owner           = "parisamoosavinezhad@hotmail.com"
    CostCenter      = ""
  }
}

#----------------------------------------------
#       Enterprise Network
#----------------------------------------------
module "network_name" {
  source             = "git::https://eh4amjsb2v7ke7yzqzkviryninjny3urbbq3pbkor25hhdbo5kea@dev.azure.com/p-moosavinezhad/az-iac/_git/az-naming//vnet?ref=main"
  prefix             = var.prefix
  stage              = var.stage
  location_shortname = var.location_shortname
}

module "network" {
  source              = "git::https://eh4amjsb2v7ke7yzqzkviryninjny3urbbq3pbkor25hhdbo5kea@dev.azure.com/p-moosavinezhad/az-iac/_git/az-vnet-v2?ref=main"
  name                = module.network_name.result
  location            = module.resourcegroup.location
  resource_group_name = module.resourcegroup.name
  address_space       = local.projn.address_space
  dns_servers         = local.projn.dns_servers
  subnets             = local.projn.subnets
}

#----------------------------------------------
#       Enterprise Network
#----------------------------------------------
module "nsg_name" {
  source             = "git::https://eh4amjsb2v7ke7yzqzkviryninjny3urbbq3pbkor25hhdbo5kea@dev.azure.com/p-moosavinezhad/az-iac/_git/az-naming//nsg?ref=main"
  prefix             = var.prefix
  name               = var.name
  stage              = var.stage
  location_shortname = var.location_shortname
}

module "nsg" {
  source              = "git::https://eh4amjsb2v7ke7yzqzkviryninjny3urbbq3pbkor25hhdbo5kea@dev.azure.com/p-moosavinezhad/az-iac/_git/az-nsg-v2?ref=main"
  name                = module.nsg_name.result
  location            = module.resourcegroup.location
  resource_group_name = module.resourcegroup.name
  security_rules      = jsondecode("${path.module}/nsg-config/projn-dev-gwc.json")["vms-for-lb"]
}


# # module "pip" {
# #   for_each = toset(local.repetation)
# #   source = "git::https://eh4amjsb2v7ke7yzqzkviryninjny3urbbq3pbkor25hhdbo5kea@dev.azure.com/p-moosavinezhad/az-iac/_git/az-publicip?ref=main"

# #   public_ip_names = ["bastion"]
# #   subscription = "dev"
# #   region_short = "we"
# #   environment = "dev"
# #   product = "${each.value}"
# #   resource_long_name = "not-used-in-main"
# #   resource_group_name     = module.resourcegroup[each.value].name
# #   resource_group_location = module.resourcegroup[each.value].location

# # }

# # output "pip_output" {
# #   value = module.pip["cloudexcellence"].public_ip_ids["bastion"]
# # }



# # module "bastion" {
# #   for_each = toset(local.repetation)
# #   source = "git::https://eh4amjsb2v7ke7yzqzkviryninjny3urbbq3pbkor25hhdbo5kea@dev.azure.com/p-moosavinezhad/az-iac/_git/az-bastion?ref=main"

# #   subscription = "dev"
# #   region_short = "we"
# #   environment = "dev"
# #   product = "${each.value}"
# #   resource_long_name = "not-used-in-main"
# #   resource_group_name     = module.resourcegroup[each.value].name
# #   resource_group_location = module.resourcegroup[each.value].location
# #   bastion_subnet_id = module.network[each.value].subnets["bastion"].id
# #   public_ip_address_id = module.pip[each.value].public_ip_ids["bastion"]
# # }

# # module "internal_lb" {
# #   for_each = toset(local.repetation)
# #   source = "git::https://eh4amjsb2v7ke7yzqzkviryninjny3urbbq3pbkor25hhdbo5kea@dev.azure.com/p-moosavinezhad/az-iac/_git/az-loadbalancer//internal?ref=main"

# #   frontend_name = "frontend_1"
# #   backend_pool_name = "backendend_1"
# #   resource_long_name = "${each.value}-${local.subscription}-${local.region_short}-${local.environment}"
# #   resource_group_name     = module.resourcegroup[each.value].name
# #   resource_group_location = module.resourcegroup[each.value].location
# #   frontend_subnet_id = module.network[each.value].subnets["lb-intern"].id
# #   tags = {
# #     Service         = "network"
# #     AssetName       = "Asset Name"
# #     AssetID         = "AB00CD"
# #     BusinessUnit    = "Network Team"
# #     Confidentiality = "C1"
# #     Integrity       = "I1"
# #     Availability    = "A1"
# #     Criticality     = "Low"
# #     Owner           = "parisamoosavinezhad@hotmail.com"
# #     CostCenter      = ""
# #   }
# # }

# module "networkwatcher_name" {
#   source   = "git::https://eh4amjsb2v7ke7yzqzkviryninjny3urbbq3pbkor25hhdbo5kea@dev.azure.com/p-moosavinezhad/az-iac/_git/az-naming//nw?ref=main"
#   prefix   = var.prefix
#   name     = var.resource_group_name
#   stage    = var.stage
#   location = var.location
# }

# module "networkwatcher" {
#   source              = "git::https://eh4amjsb2v7ke7yzqzkviryninjny3urbbq3pbkor25hhdbo5kea@dev.azure.com/p-moosavinezhad/az-iac/_git/az-networkwatcher?ref=main"
#   name                = module.networkwatcher_name.result
#   resource_group_name = module.resourcegroup.name
#   location            = module.resourcegroup.location
# }

# output "networkwatcher_output" {
#   value = module.networkwatcher
# }

# # module "privatelink_blob" {
# #   for_each = toset(local.repetation)
# #   source   = "git::https://eh4amjsb2v7ke7yzqzkviryninjny3urbbq3pbkor25hhdbo5kea@dev.azure.com/p-moosavinezhad/az-iac/_git/az-dns-zones?ref=main"

# #   private_zones           = ["privatelink.blob.core.windows.net"]
# #   resource_long_name      = "${each.value}-${local.subscription}-${local.region_short}-${local.environment}"
# #   resource_group_name     = module.resourcegroup[each.value].name
# #   resource_group_location = module.resourcegroup[each.value].location
# # }

# # output "privatelink_blob_output" {
# #   value = module.privatelink_blob
# # }

# module "storageaccount_name" {
#   source = "git::https://eh4amjsb2v7ke7yzqzkviryninjny3urbbq3pbkor25hhdbo5kea@dev.azure.com/p-moosavinezhad/az-iac/_git/az-naming//st?ref=main"
#   prefix = var.prefix
#   name   = var.resource_group_name
#   stage  = var.stage
# }

# module "storageaccount" {
#   source                      = "git::https://eh4amjsb2v7ke7yzqzkviryninjny3urbbq3pbkor25hhdbo5kea@dev.azure.com/p-moosavinezhad/az-iac/_git/az-storage-account?ref=main"
#   name                        = module.storageaccount_name.result
#   resource_group_name         = module.resourcegroup.name
#   location                    = module.resourcegroup.location
#   subnet_id                   = null
#   private_dns_zone_ids        = null
#   pe_subresources             = []
#   service_endpoint_subnet_ids = []
#   log_analytics_workspace_id  = data.terraform_remote_state.monitoring.outputs.log_analytics_workspace_id
#   ip_rules                    = []
#   additional_tags = {
#     Service         = "network"
#     AssetName       = "Asset Name"
#     AssetID         = "AB00CD"
#     BusinessUnit    = "Network Team"
#     Confidentiality = "C1"
#     Integrity       = "I1"
#     Availability    = "A1"
#     Criticality     = "Low"
#     Owner           = "parisamoosavinezhad@hotmail.com"
#     CostCenter      = ""
#   }
# }

# module "nsg_name" {
#   source   = "git::https://eh4amjsb2v7ke7yzqzkviryninjny3urbbq3pbkor25hhdbo5kea@dev.azure.com/p-moosavinezhad/az-iac/_git/az-naming//nsg?ref=main"
#   prefix   = var.prefix
#   name     = var.resource_group_name
#   stage    = var.stage
#   location = var.location
# }

# module "nsg" {
#   source                              = "../az-nsg" #"git::https://eh4amjsb2v7ke7yzqzkviryninjny3urbbq3pbkor25hhdbo5kea@dev.azure.com/p-moosavinezhad/az-iac/_git/az-nsg?ref=main"
#   subnets                             = module.network.subnets
#   storage_account_id                  = module.storageaccount.id
#   network_watcher_name                = module.networkwatcher.name
#   network_watcher_resource_group_name = module.networkwatcher.resource_group_name
#   subscription                        = "dev"
#   region_short                        = "we"
#   environment                         = "dev"
#   product                             = local.product
#   name                                = module.nsg_name.result
#   resource_group_name                 = module.resourcegroup.name
#   location                            = var.location
#   log_analytics_workspace_id          = data.terraform_remote_state.monitoring.outputs.log_analytics_workspace_id
# }

# output "s" {
#   value = module.nsg
# }


# #----------------------------------------------
# #       Enterprise Point-2-Site
# #----------------------------------------------
# # module "pip" {
# #   source = "git::https://bambgiqvuckxxvwjwvbjiasmxzbxt3oiucubtx534nky7at4qn7a@dev.azure.com/p-moosavinezhad/az-iac/_git/az-publicip?ref=main"

# #   public_ips = ["p2svpn"]

# #   subscription            = local.subscription
# #   region_short            = local.region_short
# #   environment             = local.environment
# #   product                 = var.product
# #   resource_long_name      = local.resource_long_name
# #   resource_group_name     = module.resourcegroup.name
# #   resource_group_location = module.resourcegroup.location
# # }

# # module "vpn_gateway" {
# #   source = "git::https://bambgiqvuckxxvwjwvbjiasmxzbxt3oiucubtx534nky7at4qn7a@dev.azure.com/p-moosavinezhad/az-iac/_git/az-vpn-gateway?ref=main"

# #   depends_on = [module.pip, module.network]

# #   public_ip_address_id = module.pip.public_ip_ids["p2svpn"]
# #   subnet_id            = module.network.subnets["GatewaySubnet"].id

# #   subscription            = local.subscription
# #   region_short            = local.region_short
# #   environment             = local.environment
# #   product                 = var.product
# #   resource_long_name      = local.resource_long_name
# #   resource_group_name     = module.resourcegroup.name
# #   resource_group_location = module.resourcegroup.location
# # }

