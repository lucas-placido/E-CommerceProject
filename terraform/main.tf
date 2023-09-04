terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
     random = {
      source = "hashicorp/random"
      version = "3.5.1"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
  region = var.AWS_REGION
}

variable "AWS_ACCESS_KEY_ID" {
  description = "AWS Access Key"
  sensitive = true
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = "AWS Secret Access Key"
  sensitive = true
}

variable "AWS_REGION" {
  description = "Default Region"
}