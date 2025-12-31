bucket         = "flyflow-tfstate"
key            = "infra2.0/apps/auth-service/staging/terraform.tfstate"
region         = "us-east-1"
dynamodb_table = "tfstate-locking"
encrypt        = true
