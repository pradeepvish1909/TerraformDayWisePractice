terraform {
  backend "s3" {
    bucket = "backendremotebuckett"
    key = "dev6/terraform.tfstate"
    region = "us-east-1"
    use_lockfile = true
  }
}