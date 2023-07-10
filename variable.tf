variable "location" {
  type    = string
  default = "westeurope"
}

variable "prefix" {
  description = "This can be a team name as well."
  type        = string
  default     = "teamb"
}

variable "stage" {
  type    = string
  default = "dev"
}

variable "name" {
  type    = string
  default = "projb"
}

variable "location_shortname" {
  type    = string
  default = "weu"
}

variable "remote_state_storage_account_name" {
  type    = string
  default = "parisaterraform"
}

variable "remote_state_resource_group_name" {
  type    = string
  default = "tfstate"
}

variable "remote_state_key" {
  type    = string
  default = "terraform.tfstate"
}

variable "with_watcher" {
  type    = bool
  default = false
}