locals {
  projn = jsondecode(file("${path.module}/config/${var.prefix}-${var.name}-${var.stage}-${var.location_shortname}.json"))
}

module "rg_name" {
  source             = "github.com/ParisaMousavi/az-naming//rg?ref=2022.10.07"
  prefix             = var.prefix
  name               = var.name
  stage              = var.stage
  location_shortname = var.location_shortname
}

module "resourcegroup" {
  # https://{PAT}@dev.azure.com/{organization}/{project}/_git/{repo-name}
  source   = "github.com/ParisaMousavi/az-resourcegroup?ref=2022.10.07"
  location = var.location
  name     = module.rg_name.result
  tags = {
    CostCenter = "ABC000CBA"
    By         = "parisamoosavinezhad@hotmail.com"
  }
}

#----------------------------------------------
#       Enterprise Network
#----------------------------------------------
module "network_name" {
  source             = "github.com/ParisaMousavi/az-naming//vnet?ref=main"
  prefix             = var.prefix
  stage              = var.stage
  location_shortname = var.location_shortname
}

module "network" {
  source              = "github.com/ParisaMousavi/az-vnet-v2?ref=main"
  name                = module.network_name.result
  location            = module.resourcegroup.location
  resource_group_name = module.resourcegroup.name
  address_space       = local.projn.address_space
  dns_servers         = local.projn.dns_servers
  subnets             = local.projn.subnets
  additional_tags = {
    CostCenter = "ABC000CBA"
    By         = "parisamoosavinezhad@hotmail.com"
  }
}

#----------------------------------------------
#       Enterprise Network
#----------------------------------------------
module "nsg_name" {
  source             = "github.com/ParisaMousavi/az-naming//nsg?ref=main"
  prefix             = var.prefix
  name               = var.name
  stage              = var.stage
  location_shortname = var.location_shortname
}
