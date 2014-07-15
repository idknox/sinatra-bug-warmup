require "sinatra"
require "gschool_database_connection"
require "rack-flash"

class App < Sinatra::Base
  enable :sessions
  use Rack::Flash

  def initialize
    super
    @database_connection = GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"])
  end

  get "/" do
    if session[:id]
      erb :loggedin, :locals => {:cur_user => get_name(session[:id])}
    else
      erb :home
    end
  end

  get "/register" do
    erb :register
  end

  post "/registrations" do
    insert_sql = <<-SQL
      INSERT INTO users (username, email, password, name_is_hunter)
      VALUES ('#{params[:username]}', '#{params[:email]}', '#{params[:password]}', '#{params[:name_is_hunter]}')
    SQL

    @database_connection.sql(insert_sql)
    flash[:notice] = "Thanks for signing up"

    redirect "/"
  end

  post "/" do
    select_sql = <<-SQL
      SELECT username, id FROM users WHERE username = '#{params[:username]}'
    SQL
    info = @database_connection.sql(select_sql)
    session[:id] = info[0]["id"].to_i
    redirect "/"
  end

  def get_name(id)
    select_sql = <<-SQL
      SELECT username, id FROM users WHERE id = '#{id}'
    SQL
    @database_connection.sql(select_sql)[0]["username"]
  end
end