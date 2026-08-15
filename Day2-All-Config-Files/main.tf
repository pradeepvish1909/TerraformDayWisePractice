resource "aws_instance" "dev" {
  ami = var.ami_id
  instance_type = var.instance_type
  tags = {
    Name = "DevInstance"
  }
}

# resource "aws_instance" "test" {
#   ami = var.ami_id
#   instance_type = var.instance_type
#   tags = {
#     Name = "TestInstance"
#   }
# }

resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "dev"
  }
}