output "pairs" {
  value = [for k,v in random_pet.this :
    "${k}|${v.id}"
  ]
}
