#!/usr/bin/env python3

import json

def handler(event, context):
    return {
        'statusCode': 200,
        'headers': {
            'Content-Type': 'text/html'
        },
        'body': "QueryString is <em>" + json.dumps(event.get('queryStringParameters'), indent=4) + "</em>"
    }
