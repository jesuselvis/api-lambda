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

data "archive_file" "lambda" {
  type        = var.type
  source_file = var.source_file
  output_path = "${path.module}/function.zip"
}

resource "aws_lambda_function" "crud_lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "${data.archive_file.lambda.output_path}"
  function_name = var.function_name
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "index.handler"

  source_code_hash = filebase64sha256(data.archive_file.lambda.output_path)

  runtime = var.runtime

  environment {
    variables = {
      foo = "bar"
    }
  }
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
    role = aws_iam_role.iam_for_lambda.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}