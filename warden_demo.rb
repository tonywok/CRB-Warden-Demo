require './lib/models/user'
require './lib/models/admin'

class WardenDemo < Sinatra::Base

  configure do
    environment = ENV['RACK_ENV'] || environment

    if connection_str = ENV['MONGOHQ_URL']
      uri  = URI.parse(connection_str)
      conn = Mongo::Connection.from_uri(connection_str)
      DATABASE = conn.db(uri.path.gsub(/^\//, ''))
      DATABASE.authenticate(uri.user, uri.password)
    else
      conn = Mongo::Connection.from_uri('mongodb://localhost')
      DATABASE = conn.db("warden_demo_#{environment}")
    end
    Admin.seed
  end

  get '/' do
    haml :home
  end

  get '/sign_in' do
    haml :sign_in
  end

  get '/request_token' do
    haml :request_token
  end

  get '/users' do
    if env['warden'].authenticated?(:admin)
      @users = User.collection.find()
      haml :list_users
    else
      redirect '/gtfo'
    end
  end

  get '/sign_out' do
    env['warden'].logout
    haml :home
  end

  # generate API token
  post '/generate_token' do
    email = params[:email]
    token = User.generate_token_for(email)
    User.collection.insert({email: params[:email],
                            api_token: token,
                            num_requests: 0})
    token
  end

  # authenticate using api_token strategy
  get '/api' do
    env['warden'].authenticate! :api_token, :scope => :api
    user = env['warden'].user(:api)
    User.inc_number_of_requests(user)
    "You are authenticated!"
  end

  # authenticate using password strategy
  post '/sign_in' do
    env['warden'].authenticate! :scope => :admin
    redirect '/users'
  end

  # unauthenticated requests are directed here
  post '/gtfo' do
    haml :gtfo
  end

  get '/gtfo' do
    haml :gtfo
  end

end
