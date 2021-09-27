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

module "network" {
  source = "git::https://bambgiqvuckxxvwjwvbjiasmxzbxt3oiucubtx534nky7at4qn7a@dev.azure.com/p-moosavinezhad/az-iac/_git/az-vnet?ref=main"

  subscription = "dev"
  region_short = "we"
  environment = "dev"
  product = "cloudexcellence"
  resource_long_name = "exc-network"
  resource_group_name = module.resourcegroup.name
  resource_group_location = module.resourcegroup.location  
}
