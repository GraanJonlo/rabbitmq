#!/bin/bash

chown rabbitmq:rabbitmq /logs
chown rabbitmq:rabbitmq /mnesia
chmod 0755 /logs
chmod 0755 /mnesia

exec /sbin/setuser rabbitmq /usr/sbin/rabbitmq-server
