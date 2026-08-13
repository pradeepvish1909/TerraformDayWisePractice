resource "aws_db_instance" "default" {
  allocated_storage    = 10
  db_name              = "myDB"
  identifier           = "rds-test"
  engine               = "postgres"
  engine_version       = "17.5"
  instance_class       = "db.t3.micro"
  username             = "dbadmin"
  
  # This tells RDS to manage the password in Secrets Manager
  manage_master_user_password = true 
  
  db_subnet_group_name = aws_db_subnet_group.sub-grp.name # Changed .id to .name
  parameter_group_name = "default.postgres17"
  backup_retention_period = 7
  backup_window           = "02:00-03:00"
  #monitoring_interval = 60
  #monitoring_role_arn = aws_iam_role.rds_monitoring.arn
  #performance_insights_enabled          = true
  #performance_insights_retention_period = 7
  maintenance_window  = "sun:04:00-sun:05:00"
  deletion_protection = false
  skip_final_snapshot = true
}
# FIXED IAM Role for Enhanced Monitoring
resource "aws_iam_role" "rds_monitoring" {
  name = "rds-monitoring-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { 
        Service = "monitoring.rds.amazonaws.com" # FIXED service principal
      }
    }]
  })
}
resource "aws_iam_role_policy_attachment" "rds_monitoring_attach" {
  role       = aws_iam_role.rds_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}
resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "dev"
  }
}
resource "aws_subnet" "subnet-1" {
  vpc_id = aws_vpc.name.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a"
}
resource "aws_subnet" "subnet-2" {
  vpc_id = aws_vpc.name.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1b"
}
resource "aws_db_subnet_group" "sub-grp" {
  name = "mycutsubnet"
  subnet_ids = [ aws_subnet.subnet-1.id, aws_subnet.subnet-2.id ]
  tags = {
    Name = "My DB Subnet Group"
  }
}
