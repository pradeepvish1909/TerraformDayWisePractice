terraform {
  backend "s3" {
    bucket = "backendremotebucket"
    key = "dev1/terraform.tfstate"
    region = "us-east-1"
  }
}