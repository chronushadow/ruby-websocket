FROM ruby:2.4.4
LABEL Name=ruby-websocket Version=0.0.1

ENV APP_ROOT=/usr/local/src/ruby-ws

RUN  apt-get -y update

WORKDIR ${APP_ROOT}
COPY Gemfile ${APP_ROOT}
COPY websocket.rb ${APP_ROOT}
COPY config.ru ${APP_ROOT}

RUN bundle install

EXPOSE 80
ENTRYPOINT [ "thin", "start", "-R", "config.ru", "-p", "80" ]