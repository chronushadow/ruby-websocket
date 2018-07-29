require 'faye/websocket'
require 'time'

App = lambda { |env|
  if Faye::WebSocket.websocket?(env)
    ws = Faye::WebSocket.new(env)

    ws.on :open do |event|
      puts "Connection opened"
    end

    ws.on :message do |event|
      recieved_time = Time.now

      puts "Recieved message: #{event.data}"
      client_send_time = Time.iso8601(event.data)

      puts "Time from client to server: #{recieved_time - client_send_time} [s]"

      ws.send(Time.now.strftime("%Y-%m-%dT%H:%M:%S.%6N"))
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