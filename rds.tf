data "aws_secretsmanager_secret" "db_credentials" {
  name = "mariadb-credentials"
}

data "aws_secretsmanager_secret_version" "db_credentials_secret" {
  secret_id = data.aws_secretsmanager_secret.db_credentials.id
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "my_db_subnet_group"
  #subnet_ids = [aws_subnet.private.id, aws_subnet.private_subnet_b.id]
  subnet_ids = aws_subnet.private[*].id
}

resource "aws_db_instance" "mariadb_master" {
  identifier          = "mariadb-master"
  engine              = "mariadb"
  instance_class      = "db.t3.medium"
  allocated_storage   = 20
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_master_sg.id]
  username            = jsondecode(data.aws_secretsmanager_secret_version.db_credentials_secret.secret_string)["username"]
  password            = jsondecode(data.aws_secretsmanager_secret_version.db_credentials_secret.secret_string)["password"]
  availability_zone   = element(data.aws_availability_zones.available.names, 1)
  skip_final_snapshot = true
}

resource "aws_db_instance" "mariadb_replica" {
  identifier           = "mariadb-replica"
  engine               = "mariadb"
  instance_class       = "db.t3.medium"
  allocated_storage    = 20
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_replica_sg.id]
  availability_zone    = element(data.aws_availability_zones.available.names, 0)
  skip_final_snapshot  = true

  replicate_source_db = aws_db_instance.mariadb_master.id
}
