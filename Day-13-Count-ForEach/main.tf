# resource "aws_instance" "dev" {
#   ami = var.ami_id
#   instance_type = var.instance_type
#   count = 2
# #   tags = {
# #     Name = "dev-instance" #here we are creating same EC2 instance with same name with different ID
# #   }
#     tags = {
#       Name = "dev-instance-${count.index}"
#     }
# }
#Different names for each instance
resource "aws_instance" "name" {
  ami = var.ami_id
  instance_type = var.instance_type
  count = length(var.env)
  tags = {
    #Name = "${var.env[count.index]}-instance" # here we are creating 3 instances with different names
    Name = var.env[count.index]
  }
}