require 'bundler'; Bundler.require
require './warden_demo'
require './lib/simple_auth'

use Rack::Session::Cookie
use Warden::Manager do |manager|
  manager.failure_app = WardenDemo
  manager.default_scope = :password

  manager.scope_defaults(:admin, :strategies => [:password],
                                 :action => 'gtfo')
  manager.scope_defaults(:api,   :strategies => [:api_token],
                                 :store => false,
                                 :action => 'gtfo')
end

run WardenDemo
