resource "random_pet" "password" {
  length = 2
}

output "password" {
  value = random_pet.password.id
}