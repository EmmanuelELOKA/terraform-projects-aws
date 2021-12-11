variable "region" {
  type    = string
  default = "us-east-1"
}
variable "vpc_cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
  default     = "10.0.0.0/16"
}
variable "subnet_cidr" {
  description = "The CIDR block for the Subnet. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
  default     = "10.0.1.0/24"
}
