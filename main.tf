locals{
  resource_long_name="${var.product}-${var.subscription}-${var.region_short}-${var.environment}"
}

module "resourcegroup" {
  source = "git::https://bambgiqvuckxxvwjwvbjiasmxzbxt3oiucubtx534nky7at4qn7a@dev.azure.com/p-moosavinezhad/az-iac/_git/az-resourcegroup?ref=main"
  // "git::https://bambgiqvuckxxvwjwvbjiasmxzbxt3oiucubtx534nky7at4qn7a@dev.azure.com/p-moosavinezhad/az-iac/_git/az-resourcegroup?ref=main"
  // https://{PAT}@dev.azure.com/{organization}/{project}/_git/{repo-name}

  region             = "westeurope"
  resource_long_name = "cloud-excellence-network-team"
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
  source = "git::https://bambgiqvuckxxvwjwvbjiasmxzbxt3oiucubtx534nky7at4qn7a@dev.azure.com/p-moosavinezhad/az-iac/_git/az-vnet?ref=main"

  subscription = var.subscription
  region_short = var.region_short
  environment = var.environment
  product = var.product
  resource_long_name =  local.resource_long_name
  resource_group_name = module.resourcegroup.name
  resource_group_location = module.resourcegroup.location  
}

#----------------------------------------------
#       Enterprise Point-2-Site
#----------------------------------------------
module "pip" {
  source = "git::https://bambgiqvuckxxvwjwvbjiasmxzbxt3oiucubtx534nky7at4qn7a@dev.azure.com/p-moosavinezhad/az-iac/_git/az-publicip?ref=main"

  public_ips = ["p2svpn"]
  
  subscription = var.subscription
  region_short = var.region_short
  environment = var.environment
  product = var.product
  resource_long_name =  local.resource_long_name
  resource_group_name = module.resourcegroup.name
  resource_group_location = module.resourcegroup.location  
}

module "vpn_gateway" {
  source = "git::https://bambgiqvuckxxvwjwvbjiasmxzbxt3oiucubtx534nky7at4qn7a@dev.azure.com/p-moosavinezhad/az-iac/_git/az-vpn-gateway?ref=main"
 
  depends_on = [module.pip]

  public_ip_address_id = module.pip.public_ip_ids["p2svpn"]
  subnet_id = module.network.subnets["GatewaySubnet"].id

  subscription = var.subscription
  region_short = var.region_short
  environment = var.environment
  product = var.product
  resource_long_name =  local.resource_long_name
  resource_group_name = module.resourcegroup.name
  resource_group_location = module.resourcegroup.location  
}

