"""
Project: Digital Twin
Module: digital_twin_kinesis_fanout_consumer.py
Description:
    Lambda function to fanout the incoming kinesis data stream into multiple
    outgoing firehose streams based on the event type.

Attributes:
    EVENT_STREAM_MAPPING (dict): Mapping of EventTypes to Lambda environmental
    variables containing firehose stream names.
"""


import os
import json
import base64
from datetime import datetime

import boto3


EVENT_STREAM_MAPPING = {
    'SimulationStartEvent': 'DIGITAL_TWIN_SIMULATION_START_EVENT_STREAM',
    'SimulationStopEvent': 'DIGITAL_TWIN_SIMULATION_STOP_EVENT_STREAM',
    'VehicleEntryEvent': 'DIGITAL_TWIN_VEHICLE_ENTRY_EVENT_STREAM',
    'VehicleExitEvent': 'DIGITAL_TWIN_VEHICLE_EXIT_EVENT_STREAM',
    'CheckpointEvent': 'DIGITAL_TWIN_CHECKPOINT_EVENT_STREAM'
}


def parse_data_stream_record(input_record):
    """Parses a Kinesis data stream record into a dictionary object.

    Args:
        input_record(dict): The Kinesis data stream record to parse.

    Returns:
        dict: Decoded dictionary object representing input record.
        Exception: Encoded string could not be parsed, possibly empty.
    """
    encoded_string = input_record['kinesis']['data']
    event_id = input_record['eventID']
    try:
        decoded_dict = json.loads(
            base64.urlsafe_b64decode(encoded_string.encode()).decode())
    except json.JSONDecodeError as e:
        print('Error: {0}'.format(e))
        print('Recieved data: {0}'.format(encoded_string))
        decoded_dict = {'EventType': 'FailedDecode', 'EventID': event_id}
    return decoded_dict


def encode_with_newline(decoded_dict):
    """Encodes a dictionary object to bytes, suffixed with a newline character.

    Args:
        decoded_dict (dict): The dictionary object to encode.

    Returns:
        bytes: The byte-encoded representation of the dictionary.
    """
    return (json.dumps(decoded_dict) + '\n').encode()


def get_stream_name(event_type):
    """Gets the kinesis stream name for a given event type.

    Args:
        event_type (str): The event type to get the stream for.

    Returns:
        str: The name of the stream for which to send the event.
    """
    stream_ref = EVENT_STREAM_MAPPING.get(event_type, 'DIGITAL_TWIN_DLQ_STREAM')
    stream_name = os.getenv(stream_ref)
    return stream_name


def lambda_handler(event, context):
    """Lambda function to fanout a data stream to multiple firehose streams.

    Args:
        event (dict): The received input records from kinesis.
        context (context): Provides runtime information to the handler.
    """
    streams = {}
    for input_record in event['Records']:
        data = parse_data_stream_record(input_record)
        data['kinesis_timestamp'] = str(datetime.now())
        event_type = data['EventType']

        encoded_data = encode_with_newline(data)
        output_record = {'Data': encoded_data}

        stream_name = get_stream_name(event_type)
        stream_records = streams.setdefault(stream_name, [])
        stream_records.append(output_record)

    firehose_client = boto3.client('firehose')
    for stream_name, stream_records in streams.items():
        firehose_client.put_record_batch(
            DeliveryStreamName=stream_name, Records=stream_records)
