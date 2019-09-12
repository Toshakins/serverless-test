terraform {
  required_version = "~> 0.12"
  backend "s3" {
    bucket = "terraform-aws-init-bucket"
    key = "serverless-test/terraform.tfstate"
    dynamodb_table = "TerraformLockTable"
    region = "eu-west-3"
    profile = "my_admin"
  }
}

provider "aws" {
  # Paris
  region = "${local.region}"
  profile = "my_admin"
}

locals {
  proj = "serverless-test"
  region = "eu-west-3"
  tags = {
    Name = "${local.proj}"
  }
}


resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

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

resource "aws_lambda_function" "initiator" {
  filename      = "lambda-functions/initiator.zip"
  function_name = "initiator"
  role          = "${aws_iam_role.iam_for_lambda.arn}"
  handler       = "index.handler"

  source_code_hash = "${filebase64sha256 (
    "lambda-functions/initiator.zip")}"

  runtime = "python3.7"
}
