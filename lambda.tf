provider "aws" {
  region = "ca-central-1"

}


# IAM role for Lambda execution
resource "aws_iam_policy" "iam_policy_for_lambda" {
  name = "aws_iam_policy_for_terraform"
  path = "/"
  description = "AWS IAM Policy for aws lambda role"
  policy = <<EOF
    {
        "Version": "2012-10-17",
        "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:*:*:log-group:/aws/lambda/*"
        }
      ]
    }
  EOF 
}

resource "aws_iam_role" "lambda_role" {
  name               = "lambda_execution_role"
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

resource "aws_iam_role_policy_attachment" "attach_iam_role_to_iam_policy"{
    role = aws_iam_role.lambda_role.name
    policy_arn = aws_iam_policy.iam_policy_for_lambda.arn 
}

# Package the Lambda function code
data "archive_file" "lambda_package_code" {
  type        = "zip"
  source_dir = "${path.module}/Lambda/"
  output_path = "${path.module}/Lambda/function.zip"
}

# Lambda function
resource "aws_lambda_function" "lambda_function" {
  filename         = "${path.module}/Lambda/function.zip"
  function_name    = "lambda_function1"
  role             = aws_iam_role.lambda_role.arn
  handler          = "function.lambda_handler"
  runtime = "python3.12"
  }

output "terraform_aws_role_output" {
    value = aws_iam_role.lambda_role.name
}

output "terraform_aws_role_arn_output" {
    value = aws_iam_role.lambda_role
}
