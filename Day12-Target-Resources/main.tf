resource "aws_instance" "name" {
  ami = "ami-098e39bafa7e7303d"
  instance_type = "t2.micro"
  tags = {
    Name = "dev-instance"
  }
}
resource "aws_s3_bucket" "name" {
  bucket = "vishnareshitdevops"
}