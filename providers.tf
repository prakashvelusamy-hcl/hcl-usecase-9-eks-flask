# Terraform Block
terraform {
  required_version = ">= 1.12.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.31"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.9"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.3"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.20"
    }
  }
}
provider "aws" {
  region  = var.region
  profile = "devops"
}
