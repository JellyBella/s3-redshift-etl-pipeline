#configure Terraform project to automatically store statefile on Amazon S3
terraform {
  backend "s3" {
    bucket = "bucket-to-secure-tf-statefile" #s3 bucket name
    key    = "dev/terraform.tfstate"         #path in s3
    region = "us-east-1"
  }
}
provider "aws" {
  region = "us-east-1"
}
