locals {
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  env = local.environment_vars.locals.environment
}

terraform {
  source = "git::git@github.com:aicloudpods/aicp-terraform.git//eks?ref=v0.4.0"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  cluster_name    = "aicp-u8s-cluster"
  vpc_name          = "aicp-vpc"
  cidr               = "10.0.0.0/16"
  kubeconfig_path    = "/Users/balamuruganguruswamy/balamurugan/kubernetes"
  private_subnets    = ["10.0.0.0/20", "10.0.32.0/20", "10.0.64.0/20"]
  public_subnets     = ["10.0.16.0/20", "10.0.48.0/20", "10.0.80.0/20"]
  availability_zones = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}