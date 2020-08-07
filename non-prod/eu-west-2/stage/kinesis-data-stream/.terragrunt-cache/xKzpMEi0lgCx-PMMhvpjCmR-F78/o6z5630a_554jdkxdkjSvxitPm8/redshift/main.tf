resource "aws_redshift_cluster" "dt-redshift-cluster" {
  cluster_identifier        = var.cluster_identifier
  database_name             = var.redshift_database_name
  master_username           = var.redshift_master_username
  master_password           = var.redshift_master_password
  node_type                 = var.redshift_node_type
  cluster_type              = var.redshift_cluster_type
  cluster_subnet_group_name = aws_redshift_subnet_group.dt_cluster_subnet_group.id
  skip_final_snapshot       = true
  iam_roles                 = [aws_iam_role.redshift_iam_role.arn]

  tags = {
    environmet = "staging"
  }

}

resource "aws_iam_role" "redshift_iam_role" {
  name               = "redshift_role"
  assume_role_policy = file("redshift_iam_role.json")

  tags = {
    environment = "staging"
  }
}

resource "aws_iam_role_policy" "redshift_iam_role_policy" {
  name   = "fb_redshift_iam_policy"
  role   = aws_iam_role.redshift_iam_role.id
  policy = file("redshift_iam_role_policy.json")
}


resource "aws_redshift_subnet_group" "dt_cluster_subnet_group" {
  name       = "dt-cluster-subnet-group"
  subnet_ids = var.redshift_subnet_ids

  tags = {
    environment = "staging"
  }
}

resource "aws_default_security_group" "redshift_security_group" {
  vpc_id = var.redshift_vpc_ids
  ingress {
    from_port   = 5439
    to_port     = 5439
    protocol    = "tcp"
    cidr_blocks = var.redshift_firehose_cidr_blocks
  }
  tags = {
    environment = "staging"
  }

}