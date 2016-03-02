FROM phusion/baseimage:0.9.18

MAINTAINER Andy Grant <andy.a.grant@gmail.com>

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    lsb-release \
    wget

RUN echo "deb http://binaries.erlang-solutions.com/debian `lsb_release -cs` contrib" | tee /etc/apt/sources.list.d/erlang-solutions.list
RUN echo 'deb http://www.rabbitmq.com/debian/ testing main' | tee /etc/apt/sources.list.d/rabbitmq.list

ENV ERLANG_VERSION 18.2
ENV ELIXIR_VERSION 1.2.3-1
ENV RABBIT_VERSION 3.6.1-1

RUN wget -O - http://binaries.erlang-solutions.com/debian/erlang_solutions.asc | apt-key add - && \
    wget -O - https://www.rabbitmq.com/rabbitmq-signing-key-public.asc | apt-key add - && \
    apt-get update && apt-get install -y \
    erlang-base-hipe=1:$ERLANG_VERSION \
    erlang-dev=1:$ERLANG_VERSION \
    erlang-nox=1:$ERLANG_VERSION \
    elixir=$ELIXIR_VERSION \
    rabbitmq-server=$RABBIT_VERSION

RUN rabbitmq-plugins enable rabbitmq_management && \
    /etc/init.d/rabbitmq-server stop

RUN rm -rf /var/lib/apt/lists/*

VOLUME ["/logs"]
VOLUME ["/mnesia"]

RUN mkdir /etc/service/rabbitmq
ADD rabbitmq.sh /etc/service/rabbitmq/run

EXPOSE 5672
EXPOSE 15672

CMD ["/sbin/my_init", "--quiet"]
