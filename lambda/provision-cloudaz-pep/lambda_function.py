import json
import boto3
from botocore.exceptions import ClientError

def lambda_handler(event, context):
    # Get stackName from event
    print(event)

    for record in event["Records"]:
        if record["eventName"] == 'INSERT' and record["dynamodb"]["NewImage"]["provisionStatus"]["S"]=='NOT_STARTED' :
            #print(record["dynamodb"]["NewImage"]["email"]["S"])
            CCAdministratorEmail=record["dynamodb"]["NewImage"]["email"]["S"]
            stackName=record["dynamodb"]["NewImage"]["stackname"]["S"]
            JPCHostname='jpc-'+stackName
            ControlCenterHostname='cc-'+stackName
            

            try:
                cf_client = boto3.client('cloudformation')
                cf_client.create_stack(
                    StackName=stackName,
                    TemplateURL='https://s3.amazonaws.com/cf-templates-serviceops/cloudazpep/servicenow/stack_unified.yaml',
                    Parameters=[
                        {
                            'ParameterKey': 'AdminPassword',
                            'ParameterValue': 'a'+stackName+'!'
                            
                        },{
                            'ParameterKey': 'APIClientSecret',
                            'ParameterValue': 'c'+stackName+'!@'
                            
                        },{
                            'ParameterKey': 'CCAdministratorEmail',
                            'ParameterValue': CCAdministratorEmail
                            
                        },{
                            'ParameterKey': 'ControlCenterHostname',
                            'ParameterValue': ControlCenterHostname
                            
                        },{
                            'ParameterKey': 'JPCHostname',
                            'ParameterValue': JPCHostname
                            
                        }
                    ],
                    TimeoutInMinutes=123,
                    NotificationARNs=[
                        'arn:aws:sns:us-west-2:948173514100:cloudaz-pep'
                    ],
                    Capabilities=[
                        'CAPABILITY_IAM'
                    ],
                    OnFailure='ROLLBACK',
                    Tags=[
                        {
                            'Key': 'Name',
                            'Value': 'cloudaz-pep'
                        },{
                            'Key': 'Owner',
                            'Value': 'Kavashgar.manimarpan@nextlabs.com'
                        }
                    ]
                )
            except ClientError as e:
                print(e.response['Error']['Message'])
