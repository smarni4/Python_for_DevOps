import boto3
from botocore.exceptions import ClientError
import logging

ec2 = boto3.resource('ec2')

def lambda_handler(event, context):
    try:
        message = event['Records'][0]['body']
        print(f"Received message: {message}")

        instance_id = 'i-000041b4d77895627'
        instance = ec2.Instance(instance_id)

        user_data = '#!/bin/bash \n python3 ./loop_function.py'
        instance.stop()
        instance.wait_until_stopped()
        instance.modify_attribute(
            UserData=user_data,
        )
        instance.start()
        instance.wait_until_running()
        logging.info('Process run in EC2 instance')
    except Exception as e:
        logging.error(f'Error running process in EC2 instance {e}')
    print('Process run in EC2')

