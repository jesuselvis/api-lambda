module "function_lambda" {
  source = "./lambda"
  type = "zip"
  source_file = "/home/jesus/jesus-local/api-lambda-dydb/src/index.mjs"
  function_name = "createBook"
  runtime = "nodejs20.x"
}

module "api-gateway" {
  source = "./api-gtw"
  integration_uri = module.function_lambda.invoke_arn_lambda
  function_name = module.function_lambda.function_name #lambda permissions

}