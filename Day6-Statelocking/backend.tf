terraform {
  backend "s3" {
    bucket = "backendremotebuckett"
    key = "dev3/terraform.tfstate"
    region = "us-east-1"
  }
}