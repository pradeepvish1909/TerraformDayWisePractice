variable "dev" {
  default = false
  type = bool
}
resource "aws_instance" "name" {
  ami = "ami-098e39bafa7e7303d"
  instance_type = "t2.micro"
  tags = {
    Name = "dev-instance"
  }
  count = var.dev ? 1 : 0
  #if dev is true then create 1 instance, if false then create 0 instance
}