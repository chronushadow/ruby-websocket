#!/bin/bash

certbot certonly --standalone --agree-tos -n -d www.chronushadow.xyz -m chronushadow@gmail.com

thin start -R config.ru &

exec $@
