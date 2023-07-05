require "kemal"

module Kemal::Sandbox
  static_headers do |response, filepath, filestat|
    if filepath =~ /\.html$/
      response.headers.add("Access-Control-Allow-Origin", "*")
    end
    response.headers.add("Content-Size", filestat.size.to_s)
  end

  serve_static({"gzip" => true, "dir_listing" => false})

  get "/" do
    "Hello World!"
  end
end

# http://0.0.0.0:3000/ does not accept the connection in WSL2
Kemal.config.host_binding = "localhost"
Kemal.run
