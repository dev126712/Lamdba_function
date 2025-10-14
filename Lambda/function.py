import logging
import json

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    message = event.get('message', 'No message provided')

    logger.info(message)

    return {
        'statusCode': 200,
        'body': json.dumps('Message logges successfull!')
    }