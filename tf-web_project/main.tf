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
  region = "us-east-1"
}

# Create VPC
resource "aws_vpc" "PrafulVPC" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = "true"
  enable_dns_support   = "true"

  tags = {
    Name = "PrafulVPC"
  }
}

# Create Public Subnet
resource "aws_subnet" "PublicSubnet" {
  vpc_id     = aws_vpc.PrafulVPC.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "PublicSubnet"
  }
}

# Create Internet Gateway 
resource "aws_internet_gateway" "Praful_IGW" {
  vpc_id = aws_vpc.PrafulVPC.id

  tags = {
    Name = "Praful_IGW"
  }
}


# Create Route Table
resource "aws_route_table" "Public_RT" {
  vpc_id = aws_vpc.PrafulVPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Praful_IGW.id
  }

  tags = {
    Name = "Public_RT"
  }
}


# Route table association

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.PublicSubnet.id
  route_table_id = aws_route_table.Public_RT.id
}

# Public Security Group

resource "aws_security_group" "Public_SG" {
  name        = "allow_traffic from internet"
  description = "Allow http inbound traffic"
  vpc_id      = aws_vpc.PrafulVPC.id

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
  ami                                  = "ami-04902260ca3d33422"
  instance_type                        = "t2.micro"
  associate_public_ip_address          = true
  key_name                             = "aws-key"
  vpc_security_group_ids               = [aws_security_group.Public_SG.id]
  subnet_id                            = aws_subnet.PublicSubnet.id
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

