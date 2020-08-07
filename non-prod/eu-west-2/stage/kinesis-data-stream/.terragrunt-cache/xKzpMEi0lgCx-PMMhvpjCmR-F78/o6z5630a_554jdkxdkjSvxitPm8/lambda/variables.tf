variable archive_filename {
  type    = string
}
variable source_file {
  type    = string
}

variable function_name {
  type    = string
}

variable lambda_description {
  type    = string
}

variable lambda_handler {
  type    = string
}
variable python_runtime {
  type    = string
}

variable lambda_fanout_iam_role {
  type    = string
}

variable lambda_fanout_iam_role_policy {
  type    = string
}

variable data_stream_name {
  type = string
}

variable batch_size {
  type = number
}

variable maximum_retry_attempts {
  type = number
}

variable lambda_timeout {
  type = number
}

variable lambda_memory_size {
  type = number
}