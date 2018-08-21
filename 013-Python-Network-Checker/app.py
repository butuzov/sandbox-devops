#!/usr/bin/env python3

import click
import csv
import collections
import os.path, sys
from icecream import ic
import asyncio

import time
import socket

Task = collections.namedtuple('Task', 'host port protocol')

# Reading flags
# -P - protocol
# -p - port
# -h - host
# -f - file


def csv_reader( cvsfile ):
    """
    Read CSV file and return list of Tasks ([]Task)
    """
    hosts = []
    with open( cvsfile, newline='') as csvfile:
        reader = csv.reader(csvfile)
        for row in reader:
            hosts.append( Task(host=row[1], port=row[2], protocol=row[0]) )
    return hosts

def return_hosts_to_check( cvsfname, host, protocol, port ):
    """
    Return List of Tasks (by calling file or making one Task)
    Raise Exception if both options not available
    """
    if cvsfname is not None:
        if os.path.exists( cvsfname ):
            return csv_reader( cvsfname )
        else:
            raise FileExistsError
    elif port is not None and protocol is not None and host is not None:
        return [ Task(host=host, port=port, protocol=protocol) ]

    raise Exception

def get_hosts(cvsfile, host, protocol, port):
    """
    Return List of Tasks and handle errors.
    """
    hosts = []
    try:
        hosts = return_hosts_to_check(cvsfile, host, protocol, port)
    except FileExistsError:
        print("Error (12): CSV File Not Found", file=sys.stderr)
        sys.exit(12)
    except Exception:
        print("Error (11): Protocol/Port/Host Argument Error", file=sys.stderr)
        sys.exit(11)

    return hosts

def run_tasks( tasks ):
    """
    Run tasks in asyncio event loop. 
    async tasks in python weird.
    """

    loop = asyncio.get_event_loop()
    for task in tasks:
        (message, error) = loop.run_until_complete(ping( task ))

        if error is not None:
            print(f"Error ({error}): {message}")
        else:
            print(message)

    loop.close()


def ping_tcp(host, port):
    """
    Perform TCP ping to any tcp service 
    """
    sckt = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sckt.settimeout(15.0)
    try:
        # while tcp only connect
        sckt.connect((host, int(port)))     
        return f'TCP: OK {host}:{port}', None
    except ConnectionRefusedError:
        return f'TCP: ConnectionRefused {host}:{port}', 14
    except socket.timeout:
        return f'TCP: TemedOut {host}:{port}', 15

def ping_udp(host, port):
    """
    Perform UDP ping to any our server.py service 
    """
    sckt = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sckt.settimeout(5.0)
    
    s = sckt.sendto( str.encode('ping'), (host, int(port)))
    # print(s, sckt.getblocking(), sckt)

    try:
        received_data = sckt.recvfrom(1024)
        return f'UDP: OK {host}:{port}', None
    except socket.timeout:
        return f'UDP: TemedOut {host}:{port}', 15

@asyncio.coroutine
def ping( task ):
    """
    Ping handler
    """

    if task.protocol.lower() == "udp":
        return ping_udp( task.host, task.port )

    if task.protocol.lower() == "tcp":
        return ping_tcp( task.host, task.port )

    else:
        return f"Unknown Protocol {task.protocol.lower()}", 13

################################################################################
# Arguments
################################################################################
@click.command()
@click.option('--cvsfile',  default=None,    help='CSV file format (PROTOCOL,HOST,PORT)')
@click.option('--protocol', default=None,          help='Protocol TCP or UDP')
@click.option('--port',     default=None,          help='Port')
@click.option('--host',     default=None,          help='Hostname or ip')
def main(cvsfile, host, protocol, port):
    hosts = get_hosts(cvsfile, host, protocol, port)

    run_tasks( hosts )

if __name__ == "__main__":
    main()
