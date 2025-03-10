# create provider blockf for aws
provider "aws" {
  region = "us-east-1"
}

# create a new vps

resource "aws_vpc" "Vpc_Terraform" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = "true"
  enable_dns_support   = "true"
  tags = {
    Name = "Vpc-terraform"
  }
}

# add initernet gateway to the vpc
resource "aws_internet_gateway" "igw-Terraform" {
  vpc_id = aws_vpc.Vpc_Terraform.id
  tags = {
    Name = "Igw-terraform"
  }
}

# add route table association
resource "aws_route_table_association" "rt-association-Terraform" {
  route_table_id = aws_route_table.public-rt-terraform.id
  subnet_id      = aws_subnet.public-subnet1.id
}

#  create subyesnets
resource "aws_subnet" "public-subnet1" {
  vpc_id     = aws_vpc.Vpc_Terraform.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "public-subnet1-terraform"
  }
}


#  add route table for routing traffic
resource "aws_route_table" "public-rt-terraform" {
  vpc_id = aws_vpc.Vpc_Terraform.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-Terraform.id
  }

  tags = {
    Name    = "public-rt-terraform"
    service = "Terraform"
  }
}

# add security group

resource "aws_security_group" "tf_SG" {
  name        = "tf_SG"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.Vpc_Terraform.id


  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  
  }
    egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}