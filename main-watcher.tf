module "watcher_name" {
  source             = "github.com/ParisaMousavi/az-naming//nw?ref=main"
  prefix             = var.prefix
  name               = var.name
  stage              = var.stage
  location_shortname = var.location_shortname
}

module "watcher" {
  count               = var.with_watcher == true ? 1 : 0
  source              = "github.com/ParisaMousavi/az-networkwatcher?ref=main"
  name                = module.watcher_name.result
  location            = module.resourcegroup.location
  resource_group_name = module.resourcegroup.name
  additional_tags = {
    CostCenter = "ABC000CBA"
    By         = "parisamoosavinezhad@hotmail.com"
  }
}