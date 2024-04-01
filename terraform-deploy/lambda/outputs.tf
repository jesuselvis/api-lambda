output "function_name" {
  description = "function name lambda"
  value = aws_lambda_function.crud_lambda.function_name
}
output "invoke_arn_lambda" {
  description = "arn"
  value = aws_lambda_function.crud_lambda.invoke_arn
}