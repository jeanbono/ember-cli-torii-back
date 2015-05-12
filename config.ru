require 'bundler'

Bundler.require(:default, ENV['RACK_ENV'])

class API < Grape::API
  use Rack::Cors do
    allow do
      origins '*'
      resource '*', headers: :any, methods: [:get, :post, :put, :delete, :options]
    end
  end
  use Rack::Session::Cookie
  use OmniAuth::Builder do
    provider :google_oauth2, '1064081317304-i7ab224ru8lm6e4dbf9k51vpfe1ds937.apps.googleusercontent.com', '', {
                               provider_ignores_state: true
                           }
    provider :facebook, '1389118841313051', '', {
                          provider_ignores_state: true
                      }
  end

  format :json

  resource :auth do
    route_param :provider do
      segment :callback do
        params do
          optional :code, type: String, desc: 'Authorization code.'
        end
        route ['GET', 'POST'] do
          { access_token: request.env['omniauth.auth']['uid'] }
        end
      end
    end
  end
end

run API