terraform {
  required_version = ">= 0.12"
}
# Specify the provider and access details
provider "aws" {
  region = var.aws_region
}
# This resource is the core take away of this example.
resource "aws_lambda_permission" "default" {
  statement_id  = "AllowExecutionFromAlexa"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.default.function_name
  principal     = "alexa-appkit.amazon.com"
}
resource "aws_lambda_function" "default" {
  filename         = "lambda_function.zip"
  source_code_hash = filebase64sha256("lambda_function.zip")
  function_name    = "terraform_lambda_alexa_example"
  role             = aws_iam_role.default.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python2.7"
}
resource "aws_iam_role" "default" {
  name = "terraform_lambda_alexa_example"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
