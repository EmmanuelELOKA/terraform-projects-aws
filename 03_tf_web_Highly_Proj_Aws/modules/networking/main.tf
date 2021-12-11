#--- modules/netwroking/main.tf ------
resource "random_integer" "random" {
    min = 1
    max = 100
  
}
resource "aws_vpc" "this" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true
    enable_dns_support =  true

    tags = {
        Name = "prp_vpc-${random_integer.random.id}"
    }    
}
resource "aws_subnet" "this" {
    count = length(var.public_cidrs)
    vpc_id = aws_vpc.this.id
    cidr_block = "${var.public_cidrs}"[count.index]
    map_public_ip_on_launch = true
    availability_zone = ["us-east-1a","us-east-1b","us-east-1c","us-east-1d"][count.index]

    tags = {
        Name = "prp_public-${count.index + 1}"
    }

}

