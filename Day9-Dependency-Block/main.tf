 # 1. Create Custom Policy 
resource "aws_iam_policy" "s3_access_policy" {
   name = "s3-access-policy"
   description = "Allow EC2 to access S3"
   policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject", 
          "s3:ListObject"
        ]
        Resource = [
            "arn:aws:s3:::my-bucket",
            "arn:aws:s3:::my-bucket/*"
        ]
      }
    ]
   })
}
 # 2. Creating IAM Role for EC2 to assume
resource "aws_iam_role" "ec2_s3_role" {
   name = "ec2-s3-role"
   assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
   })
}
# 3. Attach Policy to Role
resource "aws_iam_role_policy_attachment" "attach_s3_policy" {
  role = aws_iam_role.ec2_s3_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
  depends_on = [ aws_iam_policy.s3_access_policy ]
}
# 4. Creating profile for EC2 to use the Role
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2-instance-profile"
  role = aws_iam_role.ec2_s3_role.name
}
# 5. Launch EC2 instance
resource "aws_instance" "name" {
  instance_type = "t2.micro"
  ami = "ami-0bdc7d025135d7b49"
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
  #depends_on = [ aws_iam_instance_profile.ec2_instance_profile, aws_s3_bucket.name ]
}
resource "aws_s3_bucket" "name" {
  bucket = "vishnareshitdevops"
    depends_on = [ aws_instance.name ]
}
