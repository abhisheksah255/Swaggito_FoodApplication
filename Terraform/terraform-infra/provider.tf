terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 0.12"
}


provider "aws" {
  region = "us-east-1"
  #   profile = "default" # Change if you use a different AWS CLI profile
}