FROM phusion/baseimage:0.9.18

MAINTAINER Andy Grant <andy.a.grant@gmail.com>

ADD https://github.com/kelseyhightower/confd/releases/download/v0.11.0/confd-0.11.0-linux-amd64 /usr/local/bin/confd
RUN chmod +x /usr/local/bin/confd

RUN apt-get update && apt-get upgrade -y -o Dpkg::Options::="--force-confold"

RUN apt-get install -y \
    wget

RUN echo "deb http://binaries.erlang-solutions.com/debian `lsb_release -cs` contrib" | tee /etc/apt/sources.list.d/erlang-solutions.list
RUN echo 'deb http://www.rabbitmq.com/debian/ testing main' | tee /etc/apt/sources.list.d/rabbitmq.list

ENV ERLANG_VERSION 19.0-1
ENV RABBIT_VERSION 3.6.3-1

RUN wget -O - http://binaries.erlang-solutions.com/debian/erlang_solutions.asc | apt-key add - && \
    wget -O - https://www.rabbitmq.com/rabbitmq-release-signing-key.asc | apt-key add - && \
    apt-get update && apt-get install -y \
    erlang-base-hipe=1:$ERLANG_VERSION \
    erlang-dev=1:$ERLANG_VERSION \
    erlang-nox=1:$ERLANG_VERSION \
    rabbitmq-server=$RABBIT_VERSION

RUN rm -rf /var/lib/apt/lists/*

RUN mkdir /etc/service/rabbitmq
ADD rabbitmq.sh /etc/service/rabbitmq/run

ADD rabbitmq.toml /etc/confd/conf.d/rabbitmq.toml
ADD rabbitmq.config.tmpl /etc/confd/templates/rabbitmq.config.tmpl

RUN rabbitmq-plugins enable rabbitmq_management

VOLUME ["/var/log/rabbitmq"]
VOLUME ["/var/lib/rabbitmq/mnesia"]

EXPOSE 5672 15672

CMD ["/sbin/my_init", "--quiet"]