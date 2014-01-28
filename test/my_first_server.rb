require 'webrick'

root = File.expand_path '/'
server = WEBrick::HTTPServer.new :Port => 8080, :DocumentRoot => root

trap('INT') { server.shutdown }

server.start

server.mount_proc '/' do |req, res|
  res.status = 200
  res['Content-Type'] = 'text/text'
  res.body = res.path
end