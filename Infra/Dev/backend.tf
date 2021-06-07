terraform {
  backend "s3" {
    bucket = "asaxen-myapp-terraform-backend"
    key    = "terraform/var.env/asaxen.tfstate"
    region = "us-east-2"

    dynamodb_table = "terraform_locks"
    encrypt = true
  }
}