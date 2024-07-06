
terraform {
  backend "s3" {
    bucket = "docker-server-98772"
    key    = "dev/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
    dynamodb_table = "locktable"
  }
}