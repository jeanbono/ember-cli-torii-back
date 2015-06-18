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
    provider :google_oauth2, '1064081317304-i7ab224ru8lm6e4dbf9k51vpfe1ds937.apps.googleusercontent.com', '6d6xzFxn3D0rvdSPY9JAnkKL', {
                               provider_ignores_state: true
                           }
    provider :facebook, '1389118841313051', '877ef0da04166eb6536cf8f94acbd67b', {
                          provider_ignores_state: true
                      }
    provider :salesforce, '3MVG99qusVZJwhsklxpXkIhCoU6AgswudMSgm4EJn12d79fupe_fauayN9giDdQKW9iPZ0mSrLuJl9rwQXXCF', '2063966705634349436', {
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