resource "random_pet" "password" {
  length = 5
}

output "password" {
  value = random_pet.password.id
}