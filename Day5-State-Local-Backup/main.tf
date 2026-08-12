resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/24"
  tags = {
    Name = "dev"
  }
}

resource "aws_instance" "name" {
  ami = "ami-0bdc7d025135d7b49"
  instance_type = "t2.micro"
  tags = {
    Name = "test-instance"
  }
}