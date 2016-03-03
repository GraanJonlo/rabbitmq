FROM phusion/baseimage:0.9.18

MAINTAINER Andy Grant <andy.a.grant@gmail.com>

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    lsb-release \
    wget

RUN echo "deb http://binaries.erlang-solutions.com/debian `lsb_release -cs` contrib" | tee /etc/apt/sources.list.d/erlang-solutions.list
RUN echo 'deb http://www.rabbitmq.com/debian/ testing main' | tee /etc/apt/sources.list.d/rabbitmq.list

ENV ERLANG_VERSION 18.2
ENV RABBIT_VERSION 3.6.1-1

RUN wget -O - http://binaries.erlang-solutions.com/debian/erlang_solutions.asc | apt-key add - && \
    wget -O - https://www.rabbitmq.com/rabbitmq-signing-key-public.asc | apt-key add - && \
    apt-get update && apt-get install -y \
    erlang-base-hipe=1:$ERLANG_VERSION \
    erlang-dev=1:$ERLANG_VERSION \
    erlang-nox=1:$ERLANG_VERSION \
    rabbitmq-server=$RABBIT_VERSION

RUN mkdir /etc/service/rabbitmq
ADD rabbitmq.sh /etc/service/rabbitmq/run
ADD rabbitmq.config /etc/rabbitmq/rabbitmq.config

RUN rabbitmq-plugins enable rabbitmq_management

RUN rm -rf /var/lib/apt/lists/*

VOLUME ["/var/log/rabbitmq"]
VOLUME ["/var/lib/rabbitmq/mnesia"]

EXPOSE 5672
EXPOSE 15672

CMD ["/sbin/my_init", "--quiet"]
