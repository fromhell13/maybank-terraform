resource "aws_secretsmanager_secret" "db_credentials" {
  name = "mariadb-credentials"
}

resource "aws_secretsmanager_secret_version" "db_credentials_secret" {
  secret_id     = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = "admin"
    password = "SuperSecretPassword123!"
  })
}
