terraform {
  backend "gcs" {
    bucket = "terraform-state-joshuamkite-com"
    prefix = "terraform/state"
  }
}
