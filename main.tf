locals {
  projn     = jsondecode(file("${path.module}/config/spoke.json"))
  projn-dev = jsondecode(file("${path.module}/config/spoke-dev.json"))
  projn-qa  = jsondecode(file("${path.module}/config/spoke-qa.json"))
  projn_hub = jsondecode(file("${path.module}/config/hub.json"))
}

module "rg_name" {
  source             = "github.com/ParisaMousavi/az-naming//rg?ref=2022.10.07"
  prefix             = var.prefix
  name               = var.name
  stage              = var.stage
  assembly           = "network"
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
#       Enterprise Network Spok
# https://www.ipaddressguide.com/cidr
# subnet - aca - "10.200.16.0/21" > [10.200.16.0 - 10.200.23.255]
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
#       For Automation Machine
#----------------------------------------------
module "nsg_name" {
  source             = "github.com/ParisaMousavi/az-naming//nsg?ref=main"
  prefix             = var.prefix
  name               = var.name
  stage              = var.stage
  assembly           = "linux"
  location_shortname = var.location_shortname
}

module "nsg" {
  source              = "github.com/ParisaMousavi/az-nsg-v2?ref=main"
  name                = module.nsg_name.result
  location            = module.resourcegroup.location
  resource_group_name = module.resourcegroup.name
  security_rules = [
    {
      name                       = "HTTPS"
      priority                   = 100
      access                     = "Allow"
      direction                  = "Inbound"
      protocol                   = "Tcp"
      description                = "HTTPS: Allow inbound from any to 443"
      destination_address_prefix = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      source_port_range          = "*"
    },
    {
      name                       = "SSH"
      priority                   = 120
      access                     = "Allow"
      direction                  = "Inbound"
      protocol                   = "Tcp"
      description                = "SSH: Allow inbound from any to 22"
      destination_address_prefix = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      source_port_range          = "*"
    },
    {
      name                       = "HTTP"
      priority                   = 130
      access                     = "Allow"
      direction                  = "Inbound"
      protocol                   = "Tcp"
      description                = "HTTP: Allow inbound from any to 80"
      destination_address_prefix = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      source_port_range          = "*"
    },
  ]
  additional_tags = {
    CostCenter = "ABC000CBA"
    By         = "parisamoosavinezhad@hotmail.com"
  }
}

# resource "azurerm_subnet_network_security_group_association" "this" {
#   subnet_id                 = module.network.subnets["vm-linux"].id
#   network_security_group_id = module.nsg.id
# }



#----------------------------------------------
#       For Win Machine
#----------------------------------------------
module "nsg_win_name" {
  source             = "github.com/ParisaMousavi/az-naming//nsg?ref=main"
  prefix             = var.prefix
  name               = var.name
  stage              = var.stage
  assembly           = "win"
  location_shortname = var.location_shortname
}

# Reference link: https://github.com/Flodu31/Terraform/blob/master/Deploy_New_Environment_Provisioners/modules/2-windows_vm/1-virtual-machine.tf
module "nsg_win" {
  source              = "github.com/ParisaMousavi/az-nsg-v2?ref=main"
  name                = module.nsg_win_name.result
  location            = module.resourcegroup.location
  resource_group_name = module.resourcegroup.name
  security_rules = [
    {
      name                       = "HTTPS"
      priority                   = 100
      access                     = "Allow"
      direction                  = "Inbound"
      protocol                   = "Tcp"
      description                = "HTTPS: Allow inbound from any to 443"
      destination_address_prefix = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      source_port_range          = "*"
    },
    {
      name                       = "RDP"
      priority                   = 110
      access                     = "Allow"
      direction                  = "Inbound"
      protocol                   = "Tcp"
      description                = "RDP: Allow inbound from any to 3389"
      destination_address_prefix = "*"
      destination_port_range     = "3389"
      source_address_prefix      = "*"
      source_port_range          = "*"
    },
    {
      name                       = "SSH"
      priority                   = 120
      access                     = "Allow"
      direction                  = "Inbound"
      protocol                   = "Tcp"
      description                = "SSH: Allow inbound from any to 22"
      destination_address_prefix = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      source_port_range          = "*"
    },
    {
      name                       = "WinRM"
      priority                   = 130
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      description                = "WinRm: Allow inbound from any to 5985"
      source_port_range          = "*"
      destination_port_range     = "5985"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "HTTP"
      priority                   = 140
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      description                = "HTTP: Allow inbound from any to 80"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "SNOW-MID-SVR"
      priority                   = 150
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "*"
      description                = "Allow inbound from any to SNOW_MID_SERVER"
      source_port_range          = "*"
      destination_port_range     = "135"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]
  additional_tags = {
    CostCenter = "ABC000CBA"
    By         = "parisamoosavinezhad@hotmail.com"
  }
}


resource "azurerm_subnet_network_security_group_association" "this_win" {
  subnet_id                 = module.network.subnets["vm-win"].id
  network_security_group_id = module.nsg_win.id
}



#----------------------------------------------
#       For Bastion Subnet
#----------------------------------------------
module "nsg_bastion_name" {
  source             = "github.com/ParisaMousavi/az-naming//nsg?ref=main"
  prefix             = var.prefix
  name               = var.name
  stage              = var.stage
  assembly           = "bastion"
  location_shortname = var.location_shortname
}

module "nsg_bastion" {
  source                     = "github.com/ParisaMousavi/az-nsg-v2?ref=main"
  name                       = module.nsg_bastion_name.result
  location                   = module.resourcegroup.location
  resource_group_name        = module.resourcegroup.name
  log_analytics_workspace_id = var.with_monitor == true ? data.terraform_remote_state.monitoring.outputs.log_analytics_workspace_id : null
  security_rules = [
    {
      name                       = "AllowWebExperienceInbound"
      description                = "Allow our users in. Update this to be as restrictive as possible."
      priority                   = 100
      access                     = "Allow"
      direction                  = "Inbound"
      protocol                   = "Tcp"
      source_address_prefix      = "Internet"
      source_port_range          = "*"
      destination_address_prefix = "*"
      destination_port_range     = "443"
    },
    {
      name                       = "AllowControlPlaneInbound"
      description                = "Service Requirement. Allow control plane access. Regional Tag not yet supported."
      priority                   = 110
      access                     = "Allow"
      direction                  = "Inbound"
      protocol                   = "Tcp"
      source_address_prefix      = "GatewayManager"
      source_port_range          = "*"
      destination_address_prefix = "*"
      destination_port_range     = "443"
    },
    {
      name                       = "AllowHealthProbesInbound"
      description                = "Service Requirement. Allow Health Probes."
      priority                   = 120
      access                     = "Allow"
      direction                  = "Inbound"
      protocol                   = "Tcp"
      source_address_prefix      = "AzureLoadBalancer"
      source_port_range          = "*"
      destination_address_prefix = "*"
      destination_port_range     = "443"
    },
    {
      name                       = "AllowBastionHostToHostInbound"
      description                = "Service Requirement. Allow Required Host to Host Communication."
      priority                   = 130
      access                     = "Allow"
      direction                  = "Inbound"
      protocol                   = "Tcp"
      source_address_prefix      = "VirtualNetwork"
      source_port_range          = "*"
      destination_address_prefix = "VirtualNetwork"
      destination_port_ranges = [
        "8080",
        "5701"
      ]
    },
    {
      name                       = "DenyAllInbound"
      description                = "No further inbound traffic allowed."
      priority                   = 1000
      access                     = "Deny"
      direction                  = "Inbound"
      protocol                   = "*"
      source_address_prefix      = "*"
      source_port_range          = "*"
      destination_address_prefix = "*"
      destination_port_range     = "*"
    },
    {
      name                       = "AllowSshToVnetOutbound"
      description                = "Allow SSH out to the virtual network"
      priority                   = 100
      access                     = "Allow"
      direction                  = "Outbound"
      protocol                   = "Tcp"
      source_address_prefix      = "*"
      source_port_range          = "*"
      destination_address_prefix = "VirtualNetwork"
      destination_port_range     = "22"
    },
    {
      name                       = "AllowRdpToVnetOutbound"
      description                = "Allow RDP out to the virtual network"
      priority                   = 110
      access                     = "Allow"
      direction                  = "Outbound"
      protocol                   = "Tcp"
      source_address_prefix      = "*"
      source_port_range          = "*"
      destination_address_prefix = "VirtualNetwork"
      destination_port_range     = "3389"
    },
    {
      name                       = "AllowControlPlaneOutbound"
      description                = "Required for control plane outbound. Regional prefix not yet supported"
      priority                   = 120
      access                     = "Allow"
      direction                  = "Outbound"
      protocol                   = "Tcp"
      source_address_prefix      = "*"
      source_port_range          = "*"
      destination_address_prefix = "AzureCloud"
      destination_port_range     = "443"
    },
    {
      name                       = "AllowBastionHostToHostOutbound"
      description                = "Service Requirement. Allow Required Host to Host Communication."
      priority                   = 130
      access                     = "Allow"
      direction                  = "Outbound"
      protocol                   = "*"
      source_address_prefix      = "VirtualNetwork"
      source_port_range          = "*"
      destination_address_prefix = "VirtualNetwork"
      destination_port_ranges = [
        "8080",
        "5701"
      ]
    },
    {
      name                       = "AllowBastionCertificateValidationOutbound"
      description                = "Service Requirement. Allow Required Session and Certificate Validation."
      priority                   = 140
      access                     = "Allow"
      direction                  = "Outbound"
      protocol                   = "*"
      source_address_prefix      = "*"
      source_port_range          = "*"
      destination_address_prefix = "Internet"
      destination_port_range     = "80"
    },
    {
      name                       = "DenyAllOutbound"
      description                = "No further outbound traffic allowed."
      priority                   = 1000
      access                     = "Deny"
      direction                  = "Outbound"
      protocol                   = "*"
      source_address_prefix      = "*"
      source_port_range          = "*"
      destination_address_prefix = "*"
      destination_port_range     = "*"
    }
  ]
  additional_tags = {
    CostCenter = "ABC000CBA"
    By         = "parisamoosavinezhad@hotmail.com"
  }
}
