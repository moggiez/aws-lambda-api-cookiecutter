variable "domain_name" {
  type    = string
  default = "{{cookiecutter.domain_name}}"
}

variable "region" {
  type    = string
  default = "{{cookiecutter.aws_region}}"
}

variable "account" {
  type    = string
  default = "{{cookiecutter.aws_account_id}}"
}

{% if cookiecutter.use_authorization == "yes" %}
variable "user_pool_id" {
  type    = string
  default = "{{cookiecutter.aws_cognito_user_pool_id}}"
}
{% endif %}