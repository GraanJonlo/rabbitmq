# What is RabbitMQ?

RabbitMQ is an open source message broker software (sometimes called message-oriented middleware) that implements the Advanced Message Queuing Protocol (AMQP). The RabbitMQ server is written in the Erlang programming language and is built on the Open Telecom Platform framework for clustering and failover. Client libraries to interface with the broker are available for all major programming languages.

> [wikipedia.org/wiki/RabbitMQ](https://en.wikipedia.org/wiki/RabbitMQ)

![logo](https://www.rabbitmq.com/img/rabbitmq_logo_strap.png)

# How to use this image

## create and start a rabbit instance

    docker run --name some-rabbit [-p 15672:15672] [-p 5672:5672] -d graanjonlo/rabbitmq:[tag]

This image includes `EXPOSE 15672` and `EXPOSE 5672`, so standard container linking will make it automatically available to the linked containers. It also includes `VOLUME ["/var/log/rabbitmq"]` and `VOLUME ["/var/lib/rabbitmq/mnesia"]` so you can mount log and data volumes.
