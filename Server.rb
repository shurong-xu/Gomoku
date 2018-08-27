class Server
  def initialize
    @server = TCPServer.new(local_ip, 4481)
    puts "主机IP地址： #{@server.local_address.ip_address}"
    @storage = {}
    @storage["hello"] = "welcome"
  end
      
  def start
    Socket.accept_loop(@server) do |connection|
      handle(connection)
      connection.close
    end
  end
      
  def handle(connection)
    request = connection.read
    connection.write process(request)
  end

  def process(request)
    command, key, value = request.split("/")
    case command.upcase
    when 'GET'
      @storage[key]
    when 'SET'
      @storage[key] = value
    end
  end

  def local_ip 
    orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true  
    UDPSocket.open do |s|
      s.connect '192.168.1.1', 1
      s.addr.last
    end
  ensure
    Socket.do_not_reverse_lookup = orig
  end
end

# server = CloudHash::Server.new(4481)
# server.start