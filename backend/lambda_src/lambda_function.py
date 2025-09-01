import json
import os
import re
import boto3


ses = boto3.client("ses")
RECIPIENT_MAIL = os.environ.get("RECIPIENT_MAIL")
EMAIL_REGEX = re.compile(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$")


def lambda_handler(event, context):
    try:
#
#
##################### VALIDATION SECTION ####################
#
#
        if not RECIPIENT_MAIL:
            raise ValueError("RECIPIENT_MAIL environment variable is not set")
        
        data_body_string = event.get("body", "{}")
        if data_body_string is None:
            data_body_string = '{}'
        data_form = json.loads(data_body_string)


        sender_mail_form = data_form.get("sender_mail")
        subject_form = data_form.get("subject")
        message_form = data_form.get("message")

        if not all([sender_mail_form, subject_form , message_form]):
            return {
                'statusCode': 400,
                'body': json.dumps('Missing required fields: sender_mail, subject, message')
            }
        if not EMAIL_REGEX.match(sender_mail_form):
            return {
                'statusCode': 400,
                'body': json.dumps('Validation error: Provided email address is not in valid format')
            }
        
        print(f"Data loaded correctly: Mail address: {sender_mail_form}, Subject: {subject_form}, Message: {message_form}")
        
#
#
###################### MESSAGE TEMPLATE #####################
#
#

        email_body = f"""
New message received from contact form:
-----------------------------
From: {sender_mail_form}
Subject: {subject_form}
-----------------------------
Message content:
{message_form}
"""
#
#
##################### SEND EMAIL ACTION #####################
#
#      
        response = ses.send_email(
            Source=RECIPIENT_MAIL,
            Destination={
                'ToAddresses': [RECIPIENT_MAIL]
            },
            Message={
                'Subject': {'Data': subject_form, 'Charset': 'UTF-8'},
                'Body': {'Text': {'Data': email_body,'Charset': 'UTF-8'}}
            },
            ReplyToAddresses=[sender_mail_form]
        )

        return {
            'statusCode': 200,
            'body': json.dumps('Email sent successfully')
        }

#
#
####################### EXCEPTION SECTION #######################
#
#

    except json.JSONDecodeError as e:
        print(f"Error decoding JSON data: {e}")
        return {
            'statusCode': 400,
            'body': json.dumps('Error decoding JSON data')
        }
    
    except TypeError as e:
        print(f"Error decoding JSON data: {e}")
        return {
            'statusCode': 400,
            'body': json.dumps('Invalid data JSON')
        }

    except ValueError as e:
        print(f"Configuration ValueError: {e}")
        return {
            'statusCode': 500,
            'body': json.dumps('Configuration error')
        }

    except Exception as e:
        print(f"An internal error occureed: {e}")
        return {
            'statusCode': 500,
            'body': json.dumps('An internal error occureed')
        }

