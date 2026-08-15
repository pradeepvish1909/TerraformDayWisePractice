module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "single-instance"

  instance_type = "t2.micro"
  subnet_id     = "subnet-0a7c7750f5745306b"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}