resource "random_pet" "password" {
  length = var.length
  separator = var.delimiter
}

output "password" {
  value = random_pet.password.id
}

variable "length" {
  type = number
  description = "How many words should be in the password?"
}

variable "delimiter" {
  type = string
  description = "What character should separate the words in the password?"
  default = "-"
}