output "public_ip" {
  value = aws_instance.dev.public_ip
}

output "private_ip" {
  value = aws_instance.dev.private_ip
}

output "Availability_Zone" {
  value = aws_instance.dev.availability_zone
}