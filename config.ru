require 'thin'
require './websocket'

Faye::WebSocket.load_adapter('thin')
run App
