variable "aws_region" {}

variable "aws_account_id" {}

variable "delivery_stream_s3_bucket" {
  description = "The intermediatery S3 bucket"
  default     = "dt-delivery-bucket"
}


variable "s3_kms_key" {
  description = "The default KMS key for the S3"
  default     = "alias/aws/kinesis"
}

variable dt_redshift_cluster_identifier {
  type = string
}

variable dt_redshift_username {
  type = string
}
variable dt_redshift_password {
  type = string
}

variable "firehoses" {
  default = {
    simulation_start_event : {
      s3_bucket_prefix   = "simulation_start_event/",
      cloudwatch_logname = "simulation_start_event"
      data_table_name    = "digital_twin.simulation_start_event",
      data_table_columns = "scenario_id,event_type,event_time,simulation_run_id,simulation_time,user_id,simulation_start_time,incident_log,number_vehicles_generated,number_of_uk_border_gates_open,preport_compliance,preregistered_driver,rg_hmg_inspection_status_security,rg_hmg_inspection_status_biosecurity_sps,rg_hmg_inspection_status_compliance,perishable_goods,prioritised_goods,kinesis_timestamp"
    },
    simulation_stop_event : {
      s3_bucket_prefix   = "simulation_stop_event/",
      cloudwatch_logname = "simulation_stop_event"
      data_table_name    = "digital_twin.simulation_stop_event",
      data_table_columns = "scenario_id,event_type,event_time,simulation_run_id,simulation_time,simulation_stop_reason,kinesis_timestamp"
    },
    vehicle_entry_event : {
      s3_bucket_prefix   = "vehicle_entry_event/",
      cloudwatch_logname = "vehicle_entry_event"
      data_table_name    = "digital_twin.vehicle_entry_event",
      data_table_columns = "scenario_id,event_type,event_time,simulation_run_id,simulation_time,simulation_run_vehicle_id,vehicle_entry_time,vehicle_id,preport_compliance,preregistered_driver,rg_hmg_inspection_status_security,rg_hmg_inspection_status_biosecurity_sps,rg_hmg_inspection_status_compliance,perishable_goods,goods_type,prioritised_goods,kinesis_timestamp"
    },
    vehicle_exit_event : {
      s3_bucket_prefix   = "vehicle_exit_event/",
      cloudwatch_logname = "vehicle_exit_event"
      data_table_name    = "digital_twin.vehicle_exit_event",
      data_table_columns = "scenario_id,event_type,event_time,simulation_run_id,simulation_time,simulation_run_vehicle_id,vehicle_exit_time,vehicle_id,vehicle_exit_reasons,kinesis_timestamp"
    },
    checkpoint_event : {
      s3_bucket_prefix   = "checkpoint_event/",
      cloudwatch_logname = "checkpoint_event"
      data_table_name    = "digital_twin.checkpoint_event",
      data_table_columns = "scenario_id,event_type,event_time,simulation_run_id,simulation_time,checkpoint_arrival_time,checkpoint_departure_time,vehicle_id,checkpoint_id,checkpoint_name,checkpoint_group_id,checkpoint_group_name,simulation_run_vehicle_checkpoint_id,simulation_run_vehicle_id,kinesis_timestamp"
    }
  }

}
