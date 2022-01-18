terraform {
  backend "s3" {
    bucket         = "s3-${var.name}.2"
    key            = "terra/2/terraform.tfstate"
    region         = "ap-northeast-2"
  }
}