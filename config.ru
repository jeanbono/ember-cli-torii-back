require 'bundler'

Bundler.require(:default, ENV['RACK_ENV'])

class API < Grape::API
  use Rack::Cors do
    allow do
      origins '*'
      resource '*', headers: :any, methods: [:get, :post, :put, :delete, :options]
    end
  end
  use Rack::Session::Cookie, :secret => 'secret', :expire_after => 259200000
  use OmniAuth::Builder do
    provider :google_oauth2, '', '', {
                               provider_ignores_state: true
                           }
    provider :facebook, '', '', {
                          provider_ignores_state: true
                      }
    provider :salesforce, '', '', {
                         provider_ignores_state: true
                     }
  end

  format :json

  resource :auth do
    route_param :provider do
      route ['GET', 'POST'] do

      end
      segment :callback do
        params do
          optional :code, type: String, desc: 'Authorization code.'
        end
        route ['GET', 'POST'] do
          puts request.env['omniauth.auth']
          { access_token: request.env['omniauth.auth']['uid'] }
        end
      end
    end
  end
end

run API