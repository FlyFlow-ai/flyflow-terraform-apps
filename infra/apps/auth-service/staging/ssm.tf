resource "aws_ssm_parameter" "public_key_customer" {
  name  = "/githubactions/${local.name}/docker/version"
  type  = "String"
  value = "change_me"
  lifecycle {
    ignore_changes = [value]
  }
}
