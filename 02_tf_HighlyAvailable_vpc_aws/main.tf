variable "main_region" {
  type    = string
  default = "us-east-1"
}
provider "aws" {
  region = var.main_region
}

module "vpc" {
  source = "./modules/vpc"
  region = var.main_region
  
}
 
