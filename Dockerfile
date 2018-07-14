FROM ruby:2.4.4
LABEL Name=ruby-websocket Version=0.0.1

ENV APP_ROOT=/usr/local/src/ruby-ws

RUN  apt-get -y update
# RUN apt-get -y update && apt-get install -y fortunes

WORKDIR ${APP_ROOT}
COPY Gemfile ${APP_ROOT}

ENTRYPOINT [ "/bin/bash" ]