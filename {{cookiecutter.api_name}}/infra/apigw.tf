module "first_param" {
  source             = "git@github.com:moggiez/terraform-modules.git//lambda_gateway"
  api                = aws_api_gateway_rest_api._
  lambda             = module.api_lambda.lambda
  http_methods       = local.http_methods
  resource_path_part = "{hk}"
{% if cookiecutter.use_authorization == "yes" %}
  authorizer         = local.authorizer
{% endif %}
}

module "first_param_cors" {
  source          = "git@github.com:moggiez/terraform-modules.git//api_gateway_enable_cors"
  api_id          = aws_api_gateway_rest_api._.id
  api_resource_id = module.first_param.api_resource.id
}

module "fixed_part" {
  source             = "git@github.com:moggiez/terraform-modules.git//lambda_gateway"
  api                = aws_api_gateway_rest_api._
  parent_resource    = module.first_param.api_resource
  lambda             = module.api_lambda.lambda
  http_methods       = local.http_methods
  resource_path_part = "fixed_part"
{% if cookiecutter.use_authorization == "yes" %}
  authorizer         = local.authorizer
{% endif %}
}

module "fixed_param_cors" {
  source          = "git@github.com:moggiez/terraform-modules.git//api_gateway_enable_cors"
  api_id          = aws_api_gateway_rest_api._.id
  api_resource_id = module.fixed_part.api_resource.id
}

module "second_param" {
  source             = "git@github.com:moggiez/terraform-modules.git//lambda_gateway"
  api                = aws_api_gateway_rest_api._
  parent_resource    = module.fixed_part.api_resource
  lambda             = module.api_lambda.lambda
  http_methods       = local.http_methods
  resource_path_part = "{sk}"
{% if cookiecutter.use_authorization == "yes" %}
  authorizer         = local.authorizer
{% endif %}
}

module "second_param_cors" {
  source          = "git@github.com:moggiez/terraform-modules.git//api_gateway_enable_cors"
  api_id          = aws_api_gateway_rest_api._.id
  api_resource_id = module.second_param.api_resource.id
}