data "archive_file" "package_fanout_lambda" {
  type        = "zip"
  source_file = abspath("${path.module}/${var.source_file}")
  output_path = abspath("${path.module}/${var.archive_filename}")
}


resource "aws_lambda_function" "fb_kinesis_fanout_lambda_data" {
  function_name    = var.function_name
  description      = var.lambda_description
  handler          = var.lambda_handler
  runtime          = var.python_runtime
  filename         = var.archive_filename
  source_code_hash = data.archive_file.package_fanout_lambda.output_base64sha256
  role             = aws_iam_role.fb_lambda_fanout_iam_role.arn
  timeout          = var.lambda_timeout
  memory_size      = var.lambda_memory_size


  environment {
    variables = {
      DIGITAL_TWIN_CHECKPOINT_EVENT_STREAM       = "digital_twin_checkpoint_event"
      DIGITAL_TWIN_DLQ_STREAM                    = "digital_twin_dlq"
      DIGITAL_TWIN_SIMULATION_START_EVENT_STREAM = "digital_twin_simulation_start_event"
      DIGITAL_TWIN_SIMULATION_STOP_EVENT_STREAM  = "digital_twin_simulation_stop_event"
      DIGITAL_TWIN_VEHICLE_ENTRY_EVENT_STREAM    = "digital_twin_vehicle_entry_event"
      DIGITAL_TWIN_VEHICLE_EXIT_EVENT_STREAM     = "digital_twin_vehicle_exit_event"
    }
  }
}


resource "aws_iam_role" "fb_lambda_fanout_iam_role" {
  name               = var.lambda_fanout_iam_role
  assume_role_policy = file("lambda_iam_role.json")
}


resource "aws_iam_role_policy" "fb_lambda_fanout_iam_policy" {
  name   = var.lambda_fanout_iam_role_policy
  role   = aws_iam_role.fb_lambda_fanout_iam_role.id
  policy = file("lambda_iam_role_policy.json")
}


resource "aws_lambda_event_source_mapping" "lambda_event_source_mapping" {
  event_source_arn  = data.aws_kinesis_stream.fb_kinesis_data_stream.arn
  function_name     = aws_lambda_function.fb_kinesis_fanout_lambda_data.arn
  starting_position = "LATEST"
  batch_size = var.batch_size
  maximum_retry_attempts = var.maximum_retry_attempts
}

data "aws_kinesis_stream" "fb_kinesis_data_stream" {
  name = var.data_stream_name
}