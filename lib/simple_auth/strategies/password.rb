module SimpleAuth
  module Strategies
    module Password

      Warden::Manager.serialize_into_session {|admin| admin["_id"]}
      Warden::Manager.serialize_from_session {|id| Admin.collection.find({_id: id}).first}

      Warden::Manager.before_failure do |env,opts|
        # Sinatra is very sensitive to the request method
        # since authentication could fail on any type of method, we need
        # to set it for the failure app so it is routed to the correct block
        env['REQUEST_METHOD'] = "POST"
      end

      Warden::Strategies.add(:password) do
        def valid?
          params['username'] && params['password']
        end

        def authenticate!
          admin = Admin.authenticate(params['username'], params['password'])
          admin.nil? ? fail!('Invalid username or password') : success!(admin)
        end
      end

    end
  end
end
