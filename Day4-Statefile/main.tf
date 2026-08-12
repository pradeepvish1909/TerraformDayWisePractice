resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/24"
  tags = {
    Name = "dev3.0"
  }
}

resource "aws_instance" "name" {
  ami = "ami-0bdc7d025135d7b49"
  instance_type = "t2.micro"
  iam_instance_profile = "dev-instance-profile"
  tags = {
    Name = "test-instance"
  }
}