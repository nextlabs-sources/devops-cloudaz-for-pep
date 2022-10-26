import json,boto3
import hashlib,random
from botocore.exceptions import ClientError

def lambda_handler(event, context):
    # TODO implement
    print(event)
    # Email Template

    successEmailTemplate = ""
    successEmailTemplate += "<html><body>"
    successEmailTemplate += "<br>You have completed the process to setup policy server account for Entitlement Management for ServiceNow - EMSN."
    successEmailTemplate += "<br>You will receive an email for the information to complete the configuration process for EMSN."
    successEmailTemplate += "</body></html>"


    client = boto3.client('dynamodb')
    
    # Check If customer record exists already
    email=event["queryStringParameters"]['email']
    product=event["queryStringParameters"]['product']
    company=event["queryStringParameters"]['company']
    
    try:
        responseGet = client.get_item(
            Key={
                'email': {
                    'S': email
                }
            },
            TableName='cloudaz-peps',
        )
        
    except ClientError as e:
        emailExists='n'
        print(e.response['Error']['Message']) 
    else:
        if "Item" in responseGet:
                emailExists='y'
        else:
            emailExists='n'
       
    print(emailExists)
    
    # Dynamodb get number of records + 1 to form stackname
    randNum=random.randint(1, 8)
    emailPlusRandNum=email + str(randNum)
    uniqStakHash=hashlib.md5(emailPlusRandNum.encode('utf-8')).hexdigest()[0:8]
    
    if emailExists == 'y':
        return response("CloudAz already exists for you",200)
    else:
        stackName='svn'+str(uniqStakHash)
        adminPassword='a'+stackName+'@'
        aPIClientSecret='c'+stackName+'!@'
        
        Items={'email':{'S':email},'company':{'S':company},'product':{'S':product},'stackname':{'S':stackName},'APIClientSecret':{'S':aPIClientSecret},'AdminPassword':{'S':adminPassword},'provisionStatus':{'S':'NOT_STARTED'},'customerNotified':{'S':'n'}};
        
        try:
            responseDdb = client.put_item(TableName='cloudaz-peps',Item=Items)
            return response(successEmailTemplate, 200)
        
        except ClientError as e:
            return response( "<strong>"+e.response['Error']['Code']['Message'] +"</strong>", 500)

def response(message, status_code):
    return {
        'isBase64Encoded': 'false',
        'statusCode': str(status_code),
        'body': message,
        'headers': {
            'Content-Type': 'text/html',
            'Access-Control-Allow-Origin': '*'
            },
        } 