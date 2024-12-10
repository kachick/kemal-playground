require "kemal"
require "db"
require "pg"

module Kemal::Sandbox
  struct Todo
    property id, subject, done

    def initialize(@id : UUID, @subject : String, @done : Bool)
    end
  end

  database_url = "postgres://kachick@localhost:5432/postgres"

  static_headers do |context, filepath, filestat|
    if filepath =~ /\.html$/
      context.response.headers.add("Access-Control-Allow-Origin", "*")
    end
    context.response.headers.add("Content-Size", filestat.size.to_s)
  end

  serve_static({"gzip" => true, "dir_listing" => false})

  get "/ping" do
    "Hello World!"
  end

  get "/" do
    todos = [] of Todo
    DB.open(database_url) do |db|
      db.query("select id, subject, done from todos") do |rs|
        rs.each do
          todos << Todo.new(*rs.read(UUID, String, Bool))
        end
      end
    end

    render "src/views/index.ecr", "src/views/application.ecr"
  end

  get "/new" do
    render "src/views/new.ecr"
  end

  get "/todos/:id" do |env|
    id = UUID.parse?(env.params.url["id"])
    unless id
      render "src/views/error.ecr"
    end

    todo = DB.open(database_url) do |db|
      Todo.new(*db.query_one("select id, subject, done from todos where id = $1::uuid", id, as: {UUID, String, Bool}))
    end

    if todo
      render "src/views/todos/show.ecr", "src/views/application.ecr"
    else
      render "src/views/error.ecr"
    end
  end

  get "/todos/:id/edit" do |env|
    # TODO: Implement here
  end

  post "/todos" do |env|
    subject = env.params.body["subject"]
    done = env.params.body["done"] == "on"
    puts [subject, done]

    DB.open(database_url) do |db|
      db.exec("insert into todos(subject, done) values($1::text, $2::boolean)", subject, done)
    end

    env.redirect "/"
  end
end

# http://0.0.0.0:3000/ does not accept the connection in WSL2
Kemal.config.host_binding = "localhost"
Kemal.run
