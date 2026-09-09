terraform {
  backend "s3" {
    bucket = "aws-training-storage-bucket123"
    region = "eu-central-1"
    key    = "Jenkins-aws-terraform-/terraform.tfstate"
  }
}