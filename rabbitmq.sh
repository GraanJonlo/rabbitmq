#!/bin/bash

/usr/local/bin/confd -onetime -backend env

chown rabbitmq:rabbitmq /var/log/rabbitmq
chown rabbitmq:rabbitmq /var/lib/rabbitmq/mnesia
chmod -R 0755 /var/log/rabbitmq
chmod -R 0755 /var/lib/rabbitmq

exec /sbin/setuser rabbitmq /usr/sbin/rabbitmq-server
