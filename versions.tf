terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"  # Specifies the AWS provider version range (>= 5.0, < 6.0)
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"  # Specifies the Google provider version range
    }
  }
}
