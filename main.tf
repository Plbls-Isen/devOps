terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-west-3"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}





data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_lambda_function" "hour_name" {
  filename         = "lambda.zip"
  function_name    = "hour_name_g11"
  role             = aws_iam_role.iam_for_lambda.arn
  handler = "hour_name.handler"
  runtime          = "nodejs18.x"
  source_code_hash = filebase64sha256("lambda.zip")
}

resource "aws_lambda_function_url" "lambda_url" {
  function_name     = aws_lambda_function.hour_name.function_name
  authorization_type = "NONE"
}

output "lambda_url" {
  description = "L'URL pour accéder à la fonction Lambda"
  value       = aws_lambda_function_url.lambda_url.function_url
}