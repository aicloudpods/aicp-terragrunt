variable "kinesis_data_stream_names" {
  type = list(string)
  default = [
    "dt_data_stream"
  ]
}