import boto3
from botocore.exceptions import ClientError
import logging

ec2 = boto3.resource('ec2')
ssm = boto3.client('ssm')

instance_id = 'i-000041b4d77895627'


def create_sqs_queue():
    sqs = boto3.client('sqs')
    queue_name = 'my_queue'
    response = sqs.create_queue(QueueName=queue_name)
    # print(f"Queue URL: {response['QueueUrl']}")
    return response


def create_lambda_function():
    lambda_client = boto3.client('lambda')
    function_name = 'my_function'
    try:
        role = 'arn:aws:iam::930232043004:role/cfst-1449-86bbb4a990148b6a030c7c5605fa3b-LambdaRole-2V8klRboa0M1'
        handler = 'lambda_function.lambda_handler'
        zip_file = 'lambda_function.zip'
        new_response = lambda_client.create_function(
            FunctionName=function_name,
            Runtime='python3.12',
            Role=role,
            Handler=handler,
            Code=dict(ZipFile=open(zip_file, 'rb').read()),
        )
        return new_response
        # print(f"Function ARN: {new_response['Configuration']['FunctionArn']}")
    except ClientError as e:
        if e.response['Error']['Code'] == 'ResourceConflictException':
            response = lambda_client.get_function(FunctionName=function_name)
            return response
            # print(f"FunctionARN: {response['Configuration']['FunctionArn']}")
        else:
            print(e.response['Error']['Code'])


def send_message_to_sqs():
    sqs = boto3.client('sqs')
    queue_url = create_sqs_queue()['QueueUrl']
    message_body = 'Run Ec2 Process'
    try:
        response = sqs.send_message(QueueUrl=queue_url, MessageBody=message_body)
        logging.info(f"sent message: {response['MessageId']}")
    except sqs.exceptions.SQSException as e:
        logging.error(f'Error sending message to SQS {e}')


create_sqs_queue()
create_lambda_function()
send_message_to_sqs()
