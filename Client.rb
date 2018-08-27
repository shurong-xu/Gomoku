class Client
  class << self
    attr_accessor :host
  end

  def self.get(key)
    request "GET/#{key}"
  end
      
  def self.set(key, value)
    request "SET/#{key}/#{value}"
  end
      
  def self.request(string)
    @client = TCPSocket.new(host, 4481)
    @client.print(string)
    @client.close_write
    @client.read
  end
end