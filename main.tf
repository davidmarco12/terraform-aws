terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = " ~> 5.1.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

#VPC
resource "aws_vpc" "myVPC" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.vpc_name
  }
}

#Subnet
resource "aws_subnet" "mySubnet" {
  vpc_id     = aws_vpc.myVPC.id
  cidr_block = var.subnet_cidr

  tags = {
    Name = var.subnet_name
  }

}

#Create a route to the internet
resource "aws_internet_gateway" "my_ig" {
  vpc_id = aws_vpc.myVPC.id

  tags = {
    Name = var.igw_name
  }
}

#Creates new route table with IGW
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.myVPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_ig.id
  }

  tags = {
    Name = var.igw_name
  }
}

#Associates route table with subnet
resource "aws_route_table_association" "public_1_rt_assoc" {
  subnet_id      = aws_subnet.mySubnet.id
  route_table_id = aws_route_table.public_rt.id
}

#Create a new security group open to HTTP traffic
resource "aws_security_group" "app_sg" {
  name   = "HTTP"
  vpc_id = aws_vpc.myVPC.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

}


resource "aws_instance" "app_instance" {
  ami           = var.ec2_ami
  instance_type = "t2.micro"

  subnet_id                   = aws_subnet.mySubnet.id
  vpc_security_group_ids      = [aws_security_group.app_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
  #!/bin/bash -ex

  amazon-linux-extras install nginx1 -y
  echo "<h1>Este es mi server</h1>" > /usr/share/nginx/html/index.html
  systemctl enable nginx
  systemctl start nginx
  EOF


  tags = {
    Name = var.ec2_name
  }
}

resource "aws_s3_bucket_website_configuration" "aws_s3_website" {
  bucket = "my-tf-dexus-bucket"

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# resource "aws_instance" "ec2_test" {
#   ami           = "ami-011899242bb902164"
#   instance_type = "t2.micro"
#   tags = {
#     Name = "test-ec2"
#   }
# }

#  Define the VPC resource, giving it a unique name and the desired CIDR block range.
# resource "aws_vpc" "vpc" {

#   # The IPv4 CIDR block for the VPC
#   cidr_block = var.cidr_block

#   # A boolean flag to enable/disable DNS support in the VPC. Defaults to true.
#   enable_dns_support = true

#   tags = {
#     Name = "vpc"
#   }
# }
