#Choose an API type
resource "aws_apigatewayv2_api" "api_books" {
  name          = "books-api"
  protocol_type = "HTTP"
}
#agregar las integracion con lambda
resource "aws_apigatewayv2_integration" "integracion_lambda" {
  api_id           = aws_apigatewayv2_api.api_books.id
  integration_type = "AWS_PROXY"
  description               = "Lambda api books"
  integration_method        = "POST"
  integration_uri           = var.integration_uri
}
#routes
resource "aws_apigatewayv2_route" "routes" {
  api_id    = aws_apigatewayv2_api.api_books.id
  route_key = "POST /books"
  target = "integrations/${aws_apigatewayv2_integration.integracion_lambda.id}"
}
#deployment ID
resource "aws_apigatewayv2_deployment" "example_deployment" {
  api_id = aws_apigatewayv2_api.api_books.id
  description = "Deployment for example API"
}
#stages
resource "aws_apigatewayv2_stage" "stage" {
  api_id = aws_apigatewayv2_api.api_books.id
  name   = "$default"
  deployment_id = aws_apigatewayv2_deployment.example_deployment.id #attach deploy ID
}

resource "aws_lambda_permission" "api-gtw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_apigatewayv2_api.api_books.execution_arn}/*/*/books" #accesos a la ruta path
}
