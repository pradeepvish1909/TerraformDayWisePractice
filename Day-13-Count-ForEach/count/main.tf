variable "ami_id" {
  description = "Passing value to AMI_ID"
  default = ""
  type = string
}

variable "instance_type" {
  description = "Passing value to instance_type"
  default = ""
  type = string
}

# Use case 1: 
# resource "aws_instance" "dev" {
#   ami = var.ami_id
#   instance_type = var.instance_type
#   count = 2
# #   tags = {
# #     Name = "DevInstance"
# #   }
#   tags = {
#     Name = "DevInstance-${count.index}" #So here we are creating two instances with different names
#   }

# }


# Use case 2: Different names for each instance
variable "env" {
  description = "environment name"
  default = ["Dev", "Prod"]
  type = list(string)
}

resource "aws_instance" "name" {
  ami = var.ami_id
  instance_type = var.instance_type
  count = length(var.env)
  tags = {
    Name = var.env[count.index] # here we are creating 3 instances with different names
  }
}