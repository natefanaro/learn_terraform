resource "random_pet" "password" {
  length = var.length
  separator = var.delimiter
}

output "password" {
  value = random_pet.password.id
}

terraform {
  experiments = [variable_validation]
}

variable "length" {
  type = number
  description = "How many words should be in the password?"

  validation {
    condition     = var.length >= 5 && var.length <= 20
    error_message = "Length must be between 5 and 20."
  }
}

variable "delimiter" {
  type = string
  description = "What character should separate the words in the password?"
  default = "-"
}