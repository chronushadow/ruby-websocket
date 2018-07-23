FROM ruby:2.4.4
LABEL Name=ruby-websocket Version=0.0.1

ENV APP_ROOT=/usr/local/src/ruby-ws

RUN echo "deb http://ftp.debian.org/debian stretch-backports main" >> /etc/apt/sources.list
RUN  apt-get update && apt-get install -y certbot -t stretch-backports

WORKDIR ${APP_ROOT}

COPY Gemfile .
RUN bundle install

COPY websocket.rb .
COPY config.ru .

COPY docker-entrypoint.sh /usr/local/bin/

EXPOSE 80
EXPOSE 443
ENTRYPOINT [ "/usr/local/bin/docker-entrypoint.sh" ]
