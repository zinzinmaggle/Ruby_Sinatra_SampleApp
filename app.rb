require 'sinatra'
require 'sinatra/base'
require 'sinatra/flash'
require 'sass'
require 'sinatra/activerecord'
require 'warden'
require 'bcrypt'

# unless ENV['APP_ENV'] == "production"
#   require 'pry'
# end

# modular Sinatra app inherit from Sinatra::Base
class MyApp < Sinatra::Base
  # session support for your app
  use Rack::Session::Pool
  # flash messages are not integrated, yet
  # but loaded just in case someone finds the time
  register Sinatra::Flash
  register Sinatra::ActiveRecordExtension

  set :root, File.dirname(__FILE__)
  set :views, Proc.new { File.join(root, "app/views/") }
  set :database_file, './config/database.yml'
  # files in static are served on "root"
  set :public_folder, File.dirname(__FILE__) + '/public'
  # set "/views/layout.erb" as the standard/global template wrapper (yield)
  set :erb, format: :html5

end

# require libs
Dir['./lib/*.rb'].each { |file| require_relative file }
# require configurations
Dir['./config/*.rb'].each { |file| require_relative file }
# require models
Dir['./app/models/*.rb'].each { |file| require_relative file }
# require controllers
Dir['./app/controllers/*.rb'].each { |file| require_relative file }
# require routes
Dir['./app/routes/*.rb'].each { |file| require_relative file }
