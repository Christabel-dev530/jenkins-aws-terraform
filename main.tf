# VPC
resource "aws_vpc" "main2" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "jenkins_project_vpc"
  }
}
# Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main2.id
  tags = {
    Name = "my-server-IGW2"
  }
}
# Public Subnet
resource "aws_subnet" "public_subnet2" {
  vpc_id                  = aws_vpc.main2.id
  cidr_block              = var.subnet_cidr_block
  map_public_ip_on_launch = true
  tags = {
    Name = "my-server-Public-Subnet"
  }
}
# Route Table for Public Subnet
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main2.id
  tags = {
    Name = "my-server-Public-RT2"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}
# Associate Public Route Table with Public Subnet
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.public_route_table.id
}

# EC2 Instance in the Public Subnet
resource "aws_instance" "web_public" {
  ami                         = var.ami
  instance_type               = var.instance_type
  availability_zone           = var.avail_zone
  subnet_id                   = aws_subnet.public_subnet2.id
  associate_public_ip_address = true
  user_data                   = file("install-nginx.sh")
  vpc_security_group_ids      = [aws_security_group.allow_web.id]
  key_name                    = "chris"
  tags = {
    Name = "nginx_project_server1"
  }
}