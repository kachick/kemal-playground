require "kemal"

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

Kemal.run
