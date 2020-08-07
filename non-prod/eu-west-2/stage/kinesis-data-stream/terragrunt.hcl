locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env = local.environment_vars.locals.environment
}

terraform {
  source = "git::git@github.com:aicloudpods/aicp-terraform.git" #terraform's repo name -- important
}

include {
  path = find_in_parent_folders()
}