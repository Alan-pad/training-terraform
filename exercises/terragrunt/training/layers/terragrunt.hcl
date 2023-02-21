locals {
  environment = basename(get_original_terragrunt_dir())
  root_dir    = get_parent_terragrunt_dir()
}

inputs = {}


