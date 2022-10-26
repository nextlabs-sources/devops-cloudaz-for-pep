import json,boto3
from botocore.vendored import requests
import hashlib,random
import pprint

import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

from boto3.dynamodb.conditions import Key, Attr

from botocore.exceptions import ClientError

def lambda_handler(event, context):
    # TODO implement
    ddbClient = boto3.resource('dynamodb', region_name='us-west-2')
    table = ddbClient.Table('cloudaz-peps')
    
    print(event)
    # Email Template

    successEmailTemplate = ""
    successEmailTemplate += "<html><body>"
    successEmailTemplate += "<br>You have completed the process to setup policy server account for Entitlement Management for ServiceNow - EMSN."
    successEmailTemplate += "<br>You will receive an email for the information to complete the configuration process for EMSN."
    successEmailTemplate += "</body></html>"


    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('cloudaz-peps')
    
    try:
        
        responseGet = table.scan(FilterExpression=Attr('provisionStatus').eq('CREATE_COMPLETE'))
        items = responseGet['Items']
        for item in items:
            if item['customerNotified']=='n':
                jpcEndPoint='https://jpc-'+item['stackname']+'.pep.cloudaz.net/oauth/token'
                
                bodyData = {"grant_type" : "client_credentials","client_id" : "apiclient","client_secret" : item['APIClientSecret'],"expires_in":"3600"}
                headers = {'Content-Type': 'application/x-www-form-urlencoded'}
                print(jpcEndPoint)
                restResponse = requests.post(jpcEndPoint,data=bodyData, headers=headers)
                
                print('perform restAPI cal to JPC Endpoint : '+jpcEndPoint)
                
                if restResponse.json()['access_token']:
                    print("got token")
                    
                    # me == my email address
                    # you == recipient's email address
                    fromEmail =  "kavashgar@gmail.com"
                    toEmail = item['email']
                    
                    # Create message container - the correct MIME type is multipart/alternative.
                    msg = MIMEMultipart('alternative')
                    msg['Subject'] = "Link"
                    msg['From'] = fromEmail
                    msg['To'] = toEmail
                    
                    # Create the body of the message (a plain-text and an HTML version).
                   
                    html = """\
                    <html>
                      <head>
                        <style>
                            table {
                                border-collapse: collapse;
                            }
                            
                            table, td, th {
                                border: 1px solid black;
                                padding:10px;
                            }
                        </style>
                      </head>
                      <body>
                        Dear Customer,<br>
                            <h4>Thank you for signing up with NextLabs Entitlement Management.</h4><br>
                            <p>Your policy server account has been successfully setup. </p>
                            <p>Below is the information you need to access the Policy Server and to complete the configuration process of the NextLabs Entitlement Management. </p>
                           
                            <table>
                    """
                    html=html+'<tr><td>Policy Server Host </td>  <td>'
                    html=html+ 'https://'+'cc-'+str(item['stackname'])+'.pep.cloudaz.net/console'
                    html=html+'</td></tr>'
                    
                    html=html+'<tr><td style="background-color:#FF6101;color:white">Username </td>  <td>Administrator</td></tr>'
                    html=html+'<tr><td style="background-color:#FF6101;color:white">Password </td>  <td>'+item['AdminPassword']+'</td></tr>'
                    
                    html=html+'<tr><td colspan="2" ><strong>Identifier for NextLabs Entitlement Management</strong></td></tr>'
                    html=html+'<tr><td style="background-color:#FF6101;color:white">Client ID </td>  <td>EMSN</td></tr>'
                    html=html+'<tr><td style="background-color:#FF6101;color:white">Client Secret Key </td>  <td>'+item['APIClientSecret']+'</td></tr>'
                    
                    
                    html=html+"""
                    </table>
                    <p>Please proceed to the General Settings to complete the configuration process after you have installed the NextLabs Entitlement Management.</p>
                    <p>Best regards</p>
                    <p>NextLabs, Inc.</p>
                      </body>
                    </html>
                    """
                    part2 = MIMEText(html, 'html')
                    try:
                        msg.attach(part2)
                        server = smtplib.SMTP('smtp.gmail.com', 587)
                        server.starttls()
                        server.login("kavashgar@gmail.com", "cozkazvhypwavexq")
                        server.sendmail(fromEmail, toEmail, msg.as_string())
                        server.quit()
                        print("email sent successfully")
                        
                        # Now update dynamodb table with customerNotified='y' for the customerEmaill
                        try:
                            responseDdb = table.update_item(
                                                Key={
                                                    'email': item['email']
                                                    
                                                },
                                                UpdateExpression='SET customerNotified = :val1',
                                                ExpressionAttributeValues={
                                                    ':val1': 'y'
                                                }
                                            )
                            
                        except ClientError as e:
                           print(e)
                           
                           
                    except smtplib.SMTPException as e:
                        print(str(e))
                        #print("sss")

                    
                
    except ClientError as e:
        print("ff : "+e) 
    else:
        '''
        if "Item" in responseGet:
                emailExists='y'
        else:
            emailExists='n'
        '''
       
