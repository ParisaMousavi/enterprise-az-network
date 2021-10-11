//
// this file will be overwritten by terragrunt
//
// used only for unit tests - hence no defaults
//

variable "subscription" {
  description = "(provided by terragrunt)"
  type        = string
}

variable "region_short" {
  description = "(provided by terragrunt)"
  type        = string
}

variable "environment" {
  description = "(provided by terragrunt)"
  type        = string
}
variable "product" {
  description = "(provided by terragrunt)"
  type        = string
}

