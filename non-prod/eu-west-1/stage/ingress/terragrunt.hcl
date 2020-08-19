locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env = local.environment_vars.locals.environment
}

terraform {
  source = "git::git@github.com:aicloudpods/aicp-terraform.git"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  name         = var.name
  environment  = var.environment
  region       = var.region
  vpc_id       = module.vpc.id
  cluster_name = module.eks.cluster_name
}