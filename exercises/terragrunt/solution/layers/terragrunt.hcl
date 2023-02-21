locals {
  environment   = basename(get_original_terragrunt_dir())
  root_dir    = get_parent_terragrunt_dir()
}

inputs = {}

remote_state {
  backend = "local"
  config = {
    path = "${get_parent_terragrunt_dir()}/../states/${path_relative_to_include()}/terraform.tfstate"
  }

  generate = {
    path = "backend.tf"
    if_exists = "overwrite"
  }
}

