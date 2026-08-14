# S3 Bucket
resource "aws_s3_bucket" "bucket" {
  bucket = "lambda-code-buckett"
}

# Upload Zip code to S3
resource "aws_s3_object" "lambda_zip" {
  bucket = aws_s3_bucket.bucket.id
  key = "lambda/lambda_function.zip"
  source = "lambda_function.zip"
  etag = filemd5("lambda_function.zip")
}

resource "aws_iam_role" "lambda_role2" {
  name = "lambda_execution_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
            Service = "lambda.amazonaws.com"
        }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role = aws_iam_role.lambda_role2.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_s3_read" {
  role = aws_iam_role.lambda_role2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_lambda_function" "my_lambda" {
  function_name = "my_lambda_function"
  role = aws_iam_role.lambda_role2.arn
  handler = "lambda_function.lambda_handler"
  runtime = "python3.14"

  timeout = 900
  memory_size = 128

  # Code pulled from S3 (NOT local)
  s3_bucket = aws_s3_bucket.bucket.id
  s3_key = aws_s3_object.lambda_zip.key

  filename = "lambda_function.zip"

  #source_code_hash = filebase64sha256("lambda_function.zip")

}
