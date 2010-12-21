module SimpleAuth
  module Strategies

    module ApiToken
      Warden::Strategies.add(:api_token) do
        def valid?
          params['api_token']
        end

        def authenticate!
          user = User.find_by_api_token(params['api_token'])
          user.nil? ? fail!('Invalid API token') : success!(user)
        end
      end
    end

  end
end
