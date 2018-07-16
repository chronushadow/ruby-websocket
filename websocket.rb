require 'faye/websocket'

App = lambda { |env|
  if Faye::WebSocket.websocket?(env)
    ws = Faye::WebSocket.new(env)

    ws.on :open do |event|
      puts "WebSocket connection open"
    end

    ws.on :message do |event|
      puts "Recieved message: #{event.data}"
      ws.send("Pong: #{event.data}")
    end

    ws.on :close do |event|
      puts "Connection closed"
      ws = nil
    end

    ws.rack_response

  else
    [200, {'Content-Type' => 'text/plain'}, ['Hello World!']]
  end
}