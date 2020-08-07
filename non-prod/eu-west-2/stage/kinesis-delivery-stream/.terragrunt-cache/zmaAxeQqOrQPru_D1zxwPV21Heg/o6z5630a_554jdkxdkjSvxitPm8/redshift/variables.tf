variable "redshift_subnet_ids" {
  type = list(string)
  description = "The subnet ids for the subnet cluster group for the redshift config"
}


variable "redshift_vpc_ids" {
  type = string
  description = "The VPC id"
}

variable cluster_identifier {
  type = "string"
}
variable redshift_database_name {
  type = "string"

}
variable redshift_master_username {
  type = "string"

}
variable redshift_master_password {
  type = "string"

}
variable redshift_node_type {
  type = "string"

}

variable redshift_cluster_type {
  type = "string"

}

variable redshift_firehose_cidr_blocks {
  type = list(string)
}

