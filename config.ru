require 'thin'
require './websocket'

Faye::WebSocket.load_adapter('thin')
thin = Rack::Handler.get('thin')

thin.run(App, {:Host => '0.0.0.0', :Port => 443}) do |server|
  server.ssl_options = {
    :private_key_file => '/etc/letsencrypt/live/www.chronushadow.xyz/privkey.pem',
    :cert_chain_file  => '/etc/letsencrypt/live/www.chronushadow.xyz/fullchain.pem'
  }
  server.ssl = true
end