#!/bin/bash

# Wait for haproxy to start
sleep 2

# Check we are alive
haproxy -c -V -f /usr/local/etc/haproxy/haproxy.cfg
