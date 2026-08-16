resource "aws_instance" "name" {
  ami = "ami-0bdc7d025135d7b49"
  instance_type = "t2.micro"
  tags = {
    Name = "EC2"
  }
#   lifecycle {
#     create_before_destroy = true
#   }
    # lifecycle {
    #     ignore_changes = [ tags ]
    # }
    # lifecycle {
    #     ignore_changes = [ tags, instance_type ]
    # }
    lifecycle {
        prevent_destroy = true
    }
}