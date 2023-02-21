terraform {
  source = "../../../modules/other-pets"
}

locals {
  root = read_terragrunt_config(find_in_parent_folders("terragrunt.hcl"))
}

dependency "pets" {
  config_path = "${local.root.locals.root_dir}/pets/${local.root.locals.environment}"
}

inputs = {
  pets = dependency.pets.outputs.names
}
