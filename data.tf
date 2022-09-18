data "terraform_remote_state" "monitoring" {
  backend = "azurerm"
  config = {
    resource_group_name  = "tfstate"
    storage_account_name = "parisatfstateaziac2"
    container_name       = "enterprise-monitoring"
    key                  = "terraform.tfstate"
  }
}

output "monitoring" {
  value = data.terraform_remote_state.monitoring
}