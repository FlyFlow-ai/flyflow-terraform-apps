terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.32" # keep if you must, but consider upgrading later
    }
  }

  backend "s3" {}
}
