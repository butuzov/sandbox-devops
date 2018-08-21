#!python3

import asyncio

async def speak_async():
    print('OMG asynchronicity!')


loop = asyncio.get_event_loop()
for i in range(1000):
    loop.run_until_complete(speak_async())
loop.close()
