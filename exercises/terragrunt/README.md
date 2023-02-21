# Training

This exercise will show you:

- How to organize your terragrunt codebase
- How to use the dependency feature
- How to generate a backend state for each layer
- How to define generic dependencies

## Modules

First create 2 new modules in the `modules` folder

### Pets module

This module should create an arbitrary number of `random_pet` based on the `number` variable

- Variables
  - `number`
    - type: `number`
    - default: `1`
    - description: This variable is used for the number of pets this module will generate
- Outputs
  - `names`
    - type: `list(string)`
    - description: This should be a list of names generated from the `random_pet` resource

### Other-pets module

This module should create an arbitrary number of `random_pet` to pair with a list of existing `random_pet` names

- Variables
  - `names`
    - type: `list(string)`
    - default: `[]`
    - description: A list of `random_pet` names
- Ouputs
  - `pairs`
    - type: `list(string)`
    - description: Should represent the list of pairs in this format: `<FIRST_PET>|<SECOND_PET>`

## Terragrunt

### Generate the remote_state

We will use terragrunt to generate a `local` state backend. This should be set in the `terragrunt.hcl` root file.

This can be done using this:

```hcl
remote_state {
  backend = "local"
  config = {
    path = "<TO_REPLACE>"
  }

  generate = {
    path = "backend.tf"
    if_exists = "overwrite"
  }
}
```

The path should be dynamic based on the layer path. Terragrunt comes with useful functions to do that:

- `get_parent_terragrunt_dir()`
- `path_relative_to_include()`

In the end you will want to have the states stored in the `states` folder like this:

```
.
├── other-pets
│   ├── prod
│   │   └── terraform.tfstate
│   └── staging
│       └── terraform.tfstate
└── pets
    ├── prod
    │   └── terraform.tfstate
    └── staging
        └── terraform.tfstate
```

### Creating the `terragrunt.hcl` child file

Create a `terragrunt.hcl` child file that includes the following files in the given order (Merge strategy should be `deep`):

- `terragrunt.hcl` root file
- The first `module.hcl` encountered
- `inputs.hcl`

### Define the module source

In the `module.hcl` file of the two types of layers, add the terraform source block.

```
terraform {
  source = <TO_REPLACE>
}
```

Each type of layer should source a different module.

### Setup the dependency

In the `module.hcl` file of the `other-pets` layer define a dependency with the `pets` layer.

The staging other-pets layer should have a dependency with the staging pet layer (Same for prod).

This will effectively create a "generic" dependency, in order to do that you can use the variables already defined in the root `terragrunt.hcl` file.

To have access to those variables from the `module.hcl` file, you can use this (In a `locals` block):

```
root = read_terragrunt_config(find_in_parent_folders("terragrunt.hcl"))
environment = local.root.locals.environment
```

Once the dependency is setup you can use the ouput of the `pets` layer as an input in the `other-pets` layer

### Applying

If everything was done correctly you should be able to launch a terragrunt apply and :

- See the outputs of the `pets` and `other-pets` layers
- See that `other-pets` outputs correct pairs

Also try to create only 2 pets in staging and 3 in production.
