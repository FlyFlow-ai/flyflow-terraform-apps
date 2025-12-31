resource "aws_ssm_parameter" "public_key_customer" {
  name  = "/githubactions/${local.name}_${local.environment}/docker/version"
  type  = "String"
  value = "change_me"
  lifecycle {
    ignore_changes = [value]
  }
}
resource "aws_ssm_parameter" "public_key_customer" {
  name  = "/config/${local.name}_${local.environment}/spring.datasource.password"
  type  = "SecureString"
  value = random_password.postgres_password.result
}
