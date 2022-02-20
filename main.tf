locals {
  repetation = ["cloudexcellence"]
  subscription = "dev"
  region_short = "we"
  environment = "dev"
}

module "resourcegroup" {
  for_each = toset(local.repetation)
  source = "git::https://eh4amjsb2v7ke7yzqzkviryninjny3urbbq3pbkor25hhdbo5kea@dev.azure.com/p-moosavinezhad/az-iac/_git/az-resourcegroup?ref=main"
  # https://{PAT}@dev.azure.com/{organization}/{project}/_git/{repo-name}

  region             = "westeurope"
  resource_long_name = "network-${each.value}"
  tags = {
    Service         = "network"
    AssetName       = "Asset Name"
    AssetID         = "AB00CD"
    BusinessUnit    = "Network Team"
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
module "network" {
  for_each = toset(local.repetation)
  source = "git::https://eh4amjsb2v7ke7yzqzkviryninjny3urbbq3pbkor25hhdbo5kea@dev.azure.com/p-moosavinezhad/az-iac/_git/az-vnet?ref=main"

  subscription            = local.subscription
  region_short            = local.region_short
  environment             = local.environment
  product                 = "${each.value}"
  resource_long_name      = "${each.value}-${local.subscription}-${local.region_short}-${local.environment}"
  resource_group_name     = module.resourcegroup[each.value].name
  resource_group_location = module.resourcegroup[each.value].location
}


output "network_output" {
  value = module.network["cloudexcellence"].subnets
}

module "pip" {
  for_each = toset(local.repetation)
  source = "git::https://eh4amjsb2v7ke7yzqzkviryninjny3urbbq3pbkor25hhdbo5kea@dev.azure.com/p-moosavinezhad/az-iac/_git/az-publicip?ref=main"

  public_ip_names = ["bastion"]
  subscription = "dev"
  region_short = "we"
  environment = "dev"
  product = "${each.value}"
  resource_long_name = "not-used-in-main"
  resource_group_name     = module.resourcegroup[each.value].name
  resource_group_location = module.resourcegroup[each.value].location

}

output "pip_output" {
  value = module.pip["cloudexcellence"].public_ip_ids["bastion"]
}



module "bastion" {
  for_each = toset(local.repetation)
  source = "git::https://eh4amjsb2v7ke7yzqzkviryninjny3urbbq3pbkor25hhdbo5kea@dev.azure.com/p-moosavinezhad/az-iac/_git/az-bastion?ref=main"

  subscription = "dev"
  region_short = "we"
  environment = "dev"
  product = "${each.value}"
  resource_long_name = "not-used-in-main"
  resource_group_name     = module.resourcegroup[each.value].name
  resource_group_location = module.resourcegroup[each.value].location
  bastion_subnet_id = module.network[each.value].subnets["bastion"].id
  public_ip_address_id = module.pip[each.value].public_ip_ids["bastion"]
}

module "internal_lb" {
  for_each = toset(local.repetation)
  source = "git::https://eh4amjsb2v7ke7yzqzkviryninjny3urbbq3pbkor25hhdbo5kea@dev.azure.com/p-moosavinezhad/az-iac/_git/az-loadbalancer//internal?ref=main"

  frontend_name = "frontend_1"
  backend_pool_name = "backendend_1"
  resource_long_name = "${each.value}-${local.subscription}-${local.region_short}-${local.environment}"
  resource_group_name     = module.resourcegroup[each.value].name
  resource_group_location = module.resourcegroup[each.value].location
  frontend_subnet_id = module.network[each.value].subnets["lb-intern"].id
  tags = {
    Service         = "network"
    AssetName       = "Asset Name"
    AssetID         = "AB00CD"
    BusinessUnit    = "Network Team"
    Confidentiality = "C1"
    Integrity       = "I1"
    Availability    = "A1"
    Criticality     = "Low"
    Owner           = "parisamoosavinezhad@hotmail.com"
    CostCenter      = ""
  }
}

module "networkwatcher" {
  for_each = toset(local.repetation)
  source = "git::https://eh4amjsb2v7ke7yzqzkviryninjny3urbbq3pbkor25hhdbo5kea@dev.azure.com/p-moosavinezhad/az-iac/_git/az-networkwatcher?ref=main"

  subscription = "dev"
  region_short = "we"
  environment = "dev"
  product = "${each.value}"
  resource_long_name = "${each.value}-${local.subscription}-${local.region_short}-${local.environment}"
  resource_group_name     = module.resourcegroup[each.value].name
  resource_group_location = module.resourcegroup[each.value].location
}

output "networkwatcher_output" {
  value = module.networkwatcher
}

# module "storageaccount" {
#   for_each = toset(local.repetation)
#   source = "git::https://eh4amjsb2v7ke7yzqzkviryninjny3urbbq3pbkor25hhdbo5kea@dev.azure.com/p-moosavinezhad/az-iac/_git/az-storage-account?ref=main"

#   # subscription = "dev"
#   # region_short = "we"
#   # environment = "dev"
#   # product = "${each.value}"
#   resource_long_name = "${each.value}-${local.subscription}-${local.region_short}-${local.environment}"
#   resource_short_name = "${each.value}-${local.subscription}-${local.region_short}-${local.environment}"
#   resource_group_name     = module.resourcegroup[each.value].name
#   resource_group_location = module.resourcegroup[each.value].location
# }

# output "storage_output" {
#   value = module.storageaccount
# }

module "subnet" {
  for_each = toset(local.repetation)
  source = "git::https://eh4amjsb2v7ke7yzqzkviryninjny3urbbq3pbkor25hhdbo5kea@dev.azure.com/p-moosavinezhad/az-iac/_git/az-nsg?ref=main"


  subnets = module.network["cloudexcellence"].subnets
  storage_account_id = ""
  network_watcher_name = module.networkwatcher["cloudexcellence"].name
  network_watcher_resource_group_name = module.networkwatcher["cloudexcellence"].resource_group_name

  subscription = "dev"
  region_short = "we"
  environment = "dev"
  product = "${each.value}"
  resource_long_name = "${each.value}-${local.subscription}-${local.region_short}-${local.environment}"
  resource_group_name     = module.resourcegroup[each.value].name
  resource_group_location = module.resourcegroup[each.value].location
}

#----------------------------------------------
#       Enterprise Point-2-Site
#----------------------------------------------
# module "pip" {
#   source = "git::https://bambgiqvuckxxvwjwvbjiasmxzbxt3oiucubtx534nky7at4qn7a@dev.azure.com/p-moosavinezhad/az-iac/_git/az-publicip?ref=main"

#   public_ips = ["p2svpn"]

#   subscription            = local.subscription
#   region_short            = local.region_short
#   environment             = local.environment
#   product                 = var.product
#   resource_long_name      = local.resource_long_name
#   resource_group_name     = module.resourcegroup.name
#   resource_group_location = module.resourcegroup.location
# }

# module "vpn_gateway" {
#   source = "git::https://bambgiqvuckxxvwjwvbjiasmxzbxt3oiucubtx534nky7at4qn7a@dev.azure.com/p-moosavinezhad/az-iac/_git/az-vpn-gateway?ref=main"

#   depends_on = [module.pip, module.network]

#   public_ip_address_id = module.pip.public_ip_ids["p2svpn"]
#   subnet_id            = module.network.subnets["GatewaySubnet"].id

#   subscription            = local.subscription
#   region_short            = local.region_short
#   environment             = local.environment
#   product                 = var.product
#   resource_long_name      = local.resource_long_name
#   resource_group_name     = module.resourcegroup.name
#   resource_group_location = module.resourcegroup.location
# }

