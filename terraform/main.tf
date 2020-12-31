terraform {
    backend "s3" {
        bucket = "play-tfstate"
        key = "tf-circle-ecr-demo"
        region = "us-west-2"
    }
    required_providers {
        circleci = {
            source = "mrolla/circleci"
            version = "0.4.0"
        }
    }
}

provider "aws" {
    profile = "test"
    region = var.region
}

provider "circleci" {
    api_token = var.circleci_cli_token
    organization = var.organization
}