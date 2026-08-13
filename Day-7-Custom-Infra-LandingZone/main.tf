# Creation of VPC, Subnet, IGW, Route Table and Security Group in us-east-1
# VPC in us-east-1
resource "aws_vpc" "prodVPC" {
  cidr_block = "10.0.0.0/16"
  #enable_dns_support = true
  #enable_dns_hostnames = true
  tags = {
    Name = "prod-vpc"
  }
}
# Public Subnet 
resource "aws_subnet" "publicSubnet" {
  vpc_id = aws_vpc.prodVPC.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "prod-public-subnet"
  }
}
# Private Subnet
resource "aws_subnet" "privateSubnet" {
  vpc_id = aws_vpc.prodVPC.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "prod-private-subnet"
  }
}
# Internet Gateway
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.prodVPC.id
  tags = {
    Name = "prod-igw"
  }
}
# Public Route Table
resource "aws_route_table" "publicRT" {
  vpc_id = aws_vpc.prodVPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }
  tags = {
    Name = "prod-public-rt"
  }
}
resource "aws_route_table_association" "publicRTAssoc" {
  subnet_id = aws_subnet.publicSubnet.id
  route_table_id = aws_route_table.publicRT.id
}
# NAT Gateway Requirements
resource "aws_eip" "nat" {
  domain = "vpc"
  tags = {
    Name = "nat-eip"
  }
}
resource "aws_nat_gateway" "NATG" {
  allocation_id = aws_eip.nat.id
  subnet_id = aws_subnet.publicSubnet.id
  tags = {
    Name = "prod-nat-gateway"
  }
  #Ensure the Internet Gateway exists before creating the NAT Gateway
  depends_on = [ aws_internet_gateway.IGW]
}
# Private Route Table
resource "aws_route_table" "privateRT" {
  vpc_id = aws_vpc.prodVPC.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NATG.id
  }
  tags = {
    Name = "prod-private-rt"
  }
}
# Example for a single subnet
resource "aws_route_table_association" "private_assoc" {
  subnet_id = aws_subnet.privateSubnet.id
  route_table_id = aws_route_table.privateRT.id
}
# Example if you have multiple subnets (using count or for_each)
# resource "aws_route_table_association" "multi_private" {
#   count          = length(aws_subnet.private_subnets[*].id)
#   subnet_id      = aws_subnet.private_subnets[count.index].id
#   route_table_id = aws_route_table.private.id
# }
# Security Group
resource "aws_security_group" "SG1" {
  name = "prod-sg"
  description = "allow"
  vpc_id = aws_vpc.prodVPC.id
  # Inbound rule to allow SSH traffic
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Inbound rule to allow HTTP traffic
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Outbound rule to allow all traffic
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create EC2 instance
resource "aws_instance" "prodEC2" {
  ami = "ami-0bdc7d025135d7b49"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.publicSubnet.id
  vpc_security_group_ids = [aws_security_group.SG1.id]
  tags = {
    Name = "prod-instance"
  }
}