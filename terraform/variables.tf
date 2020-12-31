variable "region" {
    description = "AWS Region to use"
    type = string
    default = "us-west-2"
}

variable "environment" {
    description = "Environment"
    type = string
    default = "test"
}

variable "name" {
    description = "Name to use for resources"
    type = string
    default = "wordpress"
}

variable "organization" {
    description = "Github organization to use"
    type = string
    default = "OpsMonkeys"
}

variable "circleci_cli_token" {
    description = "CircleCI CLI Token to use"
    type = string
}

variable "tags" {
    description = "tags"
    type = map(string)

    default = {
        "managed_by" = "terraform"
    }
}