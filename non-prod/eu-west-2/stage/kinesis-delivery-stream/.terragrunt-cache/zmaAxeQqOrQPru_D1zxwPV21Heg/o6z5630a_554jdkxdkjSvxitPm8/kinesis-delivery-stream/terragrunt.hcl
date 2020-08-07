locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  env = local.environment_vars.locals.environment
}

terraform {
  source = "git::git@gitlab.com:danalyticsuk/pegasus/fb-data-terraform.git//kinesis-delivery-stream?ref=v0.3.0"
}


include {
  path = find_in_parent_folders()
}

inputs = {
  dt_redshift_cluster_identifier = "dt-redshift-cluster"
  dt_redshift_username = "awsuser"
  dt_redshift_password = "Phoenix2020"
}