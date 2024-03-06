import boto3

# basic boto3 code
"""
# YouTube link: https://www.youtube.com/watch?v=3ExnySHBO6k

# client = boto3.client('s3')

# s3_resource = boto3.resource('s3')


#  Using Client

# response = client.create_bucket(Bucket='demo-boto3-bucket147')      # This is the first api call.
# print(client.get_bucket_acl(Bucket='demo-boto3-bucket147'))       # This is the second api call to get the bucket acl.

#  Using resource

response = s3_resource.create_bucket(Bucket='demo-boto3-bucket-resource-147')        # First api call

bucket = s3_resource.Bucket('demo-boto3-bucket-resource-147')
obj = bucket.objects.all()
print(obj)
for ob in obj:
    print(ob.key)

"""

# Cost Optimization Project
"""
In this project, we will create a lambda function that checks the EBS snapshots that are no longer associated with any
active EC2 instance and deletes them to save the storage costs.

The lambda function fetches all the snapshots owned by the same account and also retrieves a list of active EC2
instances (running or stopped). For each snapshot, it checks if the associated volume (if exists) is not associated with
any active instance. If it finds a stale snapshot, it deletes it, effectively optimizing storage costs.
"""

def lambda_handler(event, context):

    # create an object for ec-2 service
    ec2 = boto3.client("ec2")

    # Get all EBS snapshots
    response = ec2.describe_snapshots(OwnerIds=['self'])

    # Get all active EC2 instance IDs
    instances_response = ec2.describe_instances(Filters=[{'Name': 'instance-state-name', 'Values': ['running']}])
    active_instance_ids = set()

    for reservation in instances_response['Reservations']:
        for instance in reservation['Instances']:
            active_instance_ids.add(instance['InstanceId'])

    # Iterate through each snapshot and delete if it is not attached to any volume or the volume is not attached to a
    # running instance.
    for snapshot in response['Snapshots']:
        snapshot_id = snapshot['SnapshotId']
        volume_id = snapshot.get('VolumeId')

        if not volume_id:
            # Delete the snapshot as it is not attached to any volume
            ec2.delete_snapshot(SnapshotId=snapshot_id)
            print(f"Deleted the snapshot {snapshot_id} as it is not attached to any volume.")
        else:
            try:
                volume_response = ec2.describe_volumes(VolumeIds=[volume_id])
                if not volume_response['Volumes'][0]['Attachments']:
                    ec2.delete_snapshot(SnapshotId=snapshot_id)
                    print(f"Deleted the snapshot {snapshot_id} as it is was taken from the volume that is not attached "
                          f"to any running instance.")
            except ec2.exceptions.ClientError as e:
                if e.response['Error']['Code'] == 'InvalidVolume.NotFound':
                    # The volume associated with the instance is not found, may be deleted.
                    ec2.delete_snapshot(SnapshotId=snapshot_id)
                    print(f"Deleted snapshot {snapshot_id} as its associated volume was not found.")
