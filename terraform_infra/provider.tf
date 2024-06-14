#configure Terraform project to automatically store statefile on Amazon S3
terraform {
  backend "s3" {
  }
}
provider "aws" {
}
