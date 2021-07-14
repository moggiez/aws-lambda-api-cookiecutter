resource "aws_dynamodb_table" "{{cookiecutter.dynamodb_table_name}}" {
  name           = "{{cookiecutter.dynamodb_table_name}}"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "HK"
  range_key      = "SK"

  attribute {
    name = "HK"
    type = "S"
  }

  attribute {
    name = "SK"
    type = "S"
  }
}