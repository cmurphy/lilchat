#!/usr/bin/env ruby

require "socket"

port = 1025
server = TCPServer.open(port)

connections = []
while (conn = server.accept)
  connections << conn
  Thread.new(conn) do |c|
    port, host = c.peeraddr[1,2]
    client = "#{host}:#{port}"
    puts "#{client} connected"
    puts "number of connections: #{connections.size}"
    begin
      loop do
        line = c.readline
        puts "#{client} says: #{line}"
	connections.each do |c|
	  c.puts(line)
	end
      end
    rescue EOFError
      connections.delete c
      c.close
      puts "#{client} has disconnected"
    end
  end
end
