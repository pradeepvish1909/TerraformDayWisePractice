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

variable "env" {
  description = "environment name"
  default = ["Dev", "Prod"]
  type = list(string)
}

resource "aws_instance" "name" {
  ami = var.ami_id
  instance_type = var.instance_type
  for_each = toset(var.env) # so here toset is used to convert list to set because for_each only only accepts map and set not lists 
  tags = {
    Name = each.key
  }
}