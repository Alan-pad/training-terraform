resource "random_pet" "this" {
  for_each = toset(var.pets)
}
