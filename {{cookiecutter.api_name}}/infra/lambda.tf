resource "aws_iam_policy" "dynamodb_access_policy" {
  name = "{{cookiecutter.api_name}}_lambda_access_dynamodb_policy"
  path = "/"

  policy = templatefile("templates/dynamo_access_policy.json", { table = aws_dynamodb_table.{{cookiecutter.dynamodb_table_name}}.name })
}

module "api_lambda" {
  source      = "git@github.com:moggiez/terraform-modules.git//lambda_with_dynamo"
  s3_bucket   = aws_s3_bucket._
  dist_dir    = "../dist"
  name        = "{{cookiecutter.api_name}}"
  policies    = [aws_iam_policy.dynamodb_access_policy.arn]
  environment = local.environment
}

resource "aws_lambda_permission" "_" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = module.api_lambda.lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api._.execution_arn}/*/*"
}