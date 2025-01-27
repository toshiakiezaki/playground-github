terraform {
  backend "s3" {
    key            = "playground-github/${var.aws_region}/terraform.tfstate"
    bucket         = "terraform-workload-data"
    region         = "us-east-1"
    profile        = "remote-state"
    dynamodb_table = "terraform-workload-lock"
  }
}
