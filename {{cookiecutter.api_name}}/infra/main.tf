terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

  # backend "s3" {
  #   bucket         = "{{cookiecutter.domain_name}}-terraform-state-backend"
  #   key            = "{{cookiecutter.api_name}}-terraform.state"
  #   region         = "eu-west-1"
  #   dynamodb_table = "{{cookiecutter.domain_name}}-{{cookiecutter.api_name}}-terraform_state"
  # }
}

provider "aws" {
  region = var.region
}

provider "aws" {
  alias  = "acm_provider"
  region = "us-east-1"
}

data "aws_route53_zone" "public" {
  private_zone = false
  name         = var.domain_name
}

locals {
  environment = "PROD"

  hosted_zone           = data.aws_route53_zone.public
{%- if cookiecutter.use_authorization == "yes" -%}
  authorization_enabled = true
{% endif %}

  # API GW Locals
  stages       = toset(["blue", "green"])
  stage        = "blue"
  http_methods = toset(["GET", "POST", "PUT", "DELETE"])
}

{%- if cookiecutter.use_authorization == "yes" -%}
locals {
  authorizer = local.authorization_enabled ? aws_api_gateway_authorizer._ : null
}
{% endif %}

resource "aws_api_gateway_rest_api" "_" {
  name        = "{{cookiecutter.api_name}}"
  description = "{{cookiecutter.api_name}} API"
}

{%- if cookiecutter.use_authorization == "yes" -%}
resource "aws_api_gateway_authorizer" "_" {
  name          = "{{cookiecutter.api_name}}-UserAuthorizer"
  rest_api_id   = aws_api_gateway_rest_api._.id
  type          = "COGNITO_USER_POOLS"
  provider_arns = ["arn:aws:cognito-idp:${var.region}:${var.account}:userpool/${var.user_pool_id}"]
}
{% endif %}