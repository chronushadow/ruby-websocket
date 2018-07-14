require 'em-websocket'

EM.run {
  EM::WebSocket.run(:host => "0.0.0.0", :port => "80") { |ws|
    ws.onopen { |handshake|
      puts "WebSocket connection open"
      ws.send "Hi client, you connected to #{handshake.path}"
    }

    ws.onclose {
      puts "Connection closed"
    }

    ws.onmessage { |msg|
      puts "Recieved message: #{msg}"
      ws.send "Pong: #{msg}"
    }
  }
}