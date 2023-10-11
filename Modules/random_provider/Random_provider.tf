terraform {
  required_providers {
    random = {
      source = "hashicorp/random"
    }
  }
}

resource "random_integer" "ri" {
  min = var.min
  max = var.max
}
