module "resourcegroup" {
  source = "git::https://p-moosavinezhad@dev.azure.com/p-moosavinezhad/az-iac/_git/az-resourcegroup?ref=main"
           // "git::https://bambgiqvuckxxvwjwvbjiasmxzbxt3oiucubtx534nky7at4qn7a@dev.azure.com/p-moosavinezhad/az-iac/_git/az-resourcegroup?ref=main"
           // https://{PAT}@dev.azure.com/{organization}/{project}/_git/{repo-name}

  region              = var.region
  tags = {
    Service           = "servivename"
    AssetName         = "Asset Name"
    AssetID           = "AB00CD"
    BusinessUnit      = "Cloud Team"
    Confidentiality   = "C1"
    Integrity         = "I1"
    Availability      = "A1"
    Criticality       = "Low"
    Owner             = "parisamoosavinezhad@hotmail.com"
    CostCenter        = ""
  }
  resource_long_name  = var.resource_long_name
}
