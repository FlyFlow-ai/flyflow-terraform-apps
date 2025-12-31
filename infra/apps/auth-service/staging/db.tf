resource "random_password" "postgres_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

module "db" {
  source  = "app.terraform.io/FlyFlow/ec2/aws"
  version = "~> 1.1.1"


  vpc_id        = "vpc-0d875e56be488e3e5"
  subnet_ids    = ["subnet-07ba043f755b81b33", "subnet-0e4525cbfb4c98ed0"]
  instance_type = "t3.nano"

  desired_count = 1
  cluster_name  = "flyflow-database"

  # optional
  ami_id    = "ami-053e7be1410d7eb72"
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get -y install postgresql postgresql-contrib

              sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /etc/postgresql/*/main/postgresql.conf
              echo "host all all 0.0.0.0/0 md5" | sudo tee -a /etc/postgresql/*/main/pg_hba.conf

              sudo systemctl enable postgresql
              sudo systemctl restart postgresql

              sudo -u postgres psql -c "ALTER USER postgres PASSWORD '${random_password.postgres_password.result}';"
              sudo -u postgres psql -c "CREATE DATABASE ${local.db_name};"
              sudo -u postgres psql -c "CREATE EXTENSION IF NOT EXISTS "uuid-ossp";"

              EOF

  storage = {
    root_volume_size      = 30
    delete_on_termination = true
  }
  security_group_ids = [aws_security_group.allow_db_access.id]
}
resource "aws_ecs_cluster" "this" {
  name = "flyflow-database"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}