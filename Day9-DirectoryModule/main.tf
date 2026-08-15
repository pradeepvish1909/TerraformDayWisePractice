# I am passing the values from Day9 to Day2, source code exist into Day2 for reusability
module "dev" {
  source = "../Day2-All-Config-Files"
  ami_id = "ami-0bdc7d025135d7b49"
  instance_type = "t2.medium"
}
