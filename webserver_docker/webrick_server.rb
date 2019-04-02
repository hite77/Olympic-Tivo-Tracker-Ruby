require 'webrick'
require 'webrick/https'

cert_name = [
  %w[CN localhost],
]
stop = false

server = WEBrick::HTTPServer.new(:Port => 443,
                                 :SSLEnable => true,
                                 :SSLCertName => cert_name)

config = { :Realm => 'DigestAuth example realm' }

htdigest = WEBrick::HTTPAuth::Htdigest.new 'my_password_file'
htdigest.set_passwd config[:Realm], 'tivo', '7773696826'
htdigest.flush

config[:UserDB] = htdigest

digest_auth = WEBrick::HTTPAuth::DigestAuth.new config

server.mount_proc '/' do |req, res|
  puts "Mapped version"
  puts "Request"
  puts req
  #if req.split("/")[1].split(" ")[0] == "quit"
  #  stop = true
  #end
  puts req["Authorization"]
  if (req["Authorization"].nil? || req["Authorization"].split(" ")[1] == "dGl2bzo3NzczNjk2ODI2")
    res.body = 'Changed:Hello, world!'
  end
end

#class Simple < WEBrick::HTTPServlet::AbstractServlet
#  def do_GET request, response
#    #status, content_type, body = do_stuff_with request
#    puts "Inside Servlet Jason"
#    response.status = 200
#    response['Content-Type'] = 'text/plain'
#    response.body = 'Hello, World!'
#  end
#end

trap 'INT' do server.shutdown; break; stop = true;  end

server.start
#server.mount '/simple', Simple

loop do
  if stop
    server.shutdown
    break;
  end
end
