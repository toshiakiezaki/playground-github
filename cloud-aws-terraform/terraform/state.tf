terraform {
  backend "s3" {
    bucket         = "terraform-workload-data"
    region         = "us-east-1"
    profile        = "remote-state"
    dynamodb_table = "terraform-workload-lock"
  }
}
