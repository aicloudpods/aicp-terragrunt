resource "aws_kinesis_stream" "fb_kinesis_data_stream" {
  for_each                  = toset(var.kinesis_data_stream_names)
  name                      = each.value
  shard_count               = 1
  retention_period          = 168
  enforce_consumer_deletion = true

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
  ]

  encryption_type = "KMS"
  kms_key_id      = "alias/aws/kinesis"

  tags = {
    environmet = "staging"
    project = "digital_twin"
  }

  provisioner "local-exec" {
    command = "aws kinesis register-stream-consumer --consumer-name fb_kinesis_data_stream_fanout_consumer --stream-arn ${aws_kinesis_stream.fb_kinesis_data_stream[each.value].arn}"
  }
}