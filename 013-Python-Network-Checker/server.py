#!/usr/bin/env python3

import socket

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.bind(('0.0.0.0', 9995))

while True:
    buf, addr = sock.recvfrom(1500)
    print(buf, addr)
    if buf.decode() == "ping":
        sock.sendto( str.encode("pong"), addr)
    if buf.decode() == "hello":
        sock.sendto( str.encode("buenos tardes amigo!"), addr)
    if buf.decode() == "Hello There!":
        sock.sendto( str.encode("General Kenobi!"), addr)
