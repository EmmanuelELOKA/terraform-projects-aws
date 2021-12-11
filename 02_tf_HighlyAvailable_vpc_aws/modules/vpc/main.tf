provider "aws" {
  region = var.region
}
# Create a VPC
resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
}
tags = {
    Name = "ModuleVPC"
  }

# Public Subnet 1
resource "aws_subnet" "this" {
  vpc_id     = aws_vpc.this.id
  cidr_block = var.Public_Subnet_Cidr1
}
# Public Subnet 2
resource "aws_subnet" "this" {
  vpc_id     = aws_vpc.this.id
  cidr_block = var.Private_Subnet_Cidr2
}

