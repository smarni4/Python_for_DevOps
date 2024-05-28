import boto3

ec2 = boto3.client('ec2')
ssm = boto3.client('ssm')

instance_id = 'i-000041b4d77895627'

command = 'python3 ./ec2_function.py'

response = ssm.send_command(
    InstanceIds=[instance_id],
    DocumentName='AWS-RunShellScript',
    Parameters={
        'commands': [command]
    }
)
