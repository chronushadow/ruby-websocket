#!/bin/bash

SSL=false

usage() {
  echo "Usage: $0 [-s] [-d domain] [-m email-address]" 1>&2
  exit 1
}

while getopts sd:m:h OPT
do
  case $OPT in
    s) SSL=true
      ;;
    d) DOMAIN=$OPTARG
      ;;
    m) EMAIL=$OPTARG
      ;;
    h) usage
      ;;
  esac
done

if $SSL ; then
  FLAG=false
  [ -z "$DOMAIN" ] && echo "Specify domain by -d argument." 1>&2 && FLAG=true
  [ -z "$EMAIL" ] && echo "Specify email address by -m argument." 1>&2 && FLAG=true

  if $FLAG ; then exit 1 ;fi

  certbot certonly --standalone --agree-tos -n -d $DOMAIN -m $EMAIL

  cd $APP_ROOT
  thin start -R config.ru -a 0.0.0.0 -p 443 --ssl --ssl-key-file /etc/letsencrypt/live/$DOMAIN/privkey.pem --ssl-cert-file /etc/letsencrypt/live/$DOMAIN/fullchain.pem

else

  cd $APP_ROOT
  thin start -R config.ru -a 0.0.0.0 -p 80

fi
