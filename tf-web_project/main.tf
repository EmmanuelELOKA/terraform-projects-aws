terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-2"
}

# Create VPC
resource "aws_vpc" "PowerFactorsVPC" {
  cidr_block           = "100.30.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = "true"
  enable_dns_support   = "true"

  tags = {
    Name = "PowerFactorsVPC"
  }
}

# Create Public Subnet
resource "aws_subnet" "PowerFactorsPublicSubnet" {
  vpc_id     = aws_vpc.PowerFactorsVPC.id
  cidr_block = "100.30.1.0/24"

  tags = {
    Name = "PowerFactorsPublicSubnet"
  }
}

# Create Internet Gateway 
resource "aws_internet_gateway" "PowerFactors_IGW" {
  vpc_id = aws_vpc.PowerFactorsVPC.id

  tags = {
    Name = "PowerFactors_IGW"
  }
}


# Create Route Table
resource "aws_route_table" "PowerFactorsPublic_RT" {
  vpc_id = aws_vpc.PowerFactorsVPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.PowerFactors_IGW.id
  }

  tags = {
    Name = "PowerFactorsPublic_RT"
  }
}


# Route table association

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.PowerFactorsPublicSubnet.id
  route_table_id = aws_route_table.PowerFactorsPublic_RT.id
}

# Public Security Group

resource "aws_security_group" "PowerFactorsPublic_SG" {
  name        = "allow_traffic from internet"
  description = "Allow http inbound traffic"
  vpc_id      = aws_vpc.PowerFactorsVPC.id

  ingress {
    description = "ssh from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "http from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }



  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_internet"
  }
}

# Create Web Server 

resource "aws_instance" "Web_server" {
  ami                                  = "ami-02d1e544b84bf7502"
  instance_type                        = "t2.micro"
  associate_public_ip_address          = true
  key_name                             = "disaster-keypair"
  vpc_security_group_ids               = [aws_security_group.PowerFactorsPublic_SG.id]
  subnet_id                            = aws_subnet.PowerFactorsPublicSubnet.id
  user_data                            = file("user-data-apache.sh")
  instance_initiated_shutdown_behavior = "terminate"
  root_block_device {
    volume_type = "gp2"
    volume_size = "8"
  }


  tags = {
    Name = "web_Server"
  }
}


output "ip" {
  value = "aws_instance.web_server.public_ip"
}

