locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env = local.environment_vars.locals.environment
}

terraform {
  source = "git::git@gitlab.com:danalyticsuk/pegasus/fb-data-terraform.git//kinesis-data-stream?ref=v0.4.0"
}

include {
  path = find_in_parent_folders()
}