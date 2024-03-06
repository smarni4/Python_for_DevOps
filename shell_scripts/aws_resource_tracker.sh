#!/bin/bash

##########################
# Author: Veera Marni
# About: This script will report the AWS resource usage of S3, EC2, Lambda Functions, IAM Users.
# Version: v1
##########################

# set -x    # Run in debug mode

cat << MARNI > resource_tracker.txt   # Used MARNI as a End of File (EOF) Delimiter.
S3 Buckets: $(aws s3 ls)
EC2 InstanceId: $(aws ec2 describe-instances | jq '.Reservations[].Instances[].InstanceId')
Lambda Functions: $(aws lambda list-functions)
IAM Users: $(aws iam list-users | jq '.Users[].UserId')
MARNI
