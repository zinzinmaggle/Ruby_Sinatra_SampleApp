class MyApp < Sinatra::Base
    use Warden::Manager do |config|
        # Tell Warden how to save our User info into a session.
        # Sessions can only take strings, not Ruby code, we'll store
        # the User's `id`
        config.serialize_into_session(&:id)
        # Now tell Warden how to take what we've stored in the session
        # and get a User from that information.
        config.serialize_from_session { |id| User.find(id) }

        config.scope_defaults :default,
                              store: true,
                              # "strategies" is an array of named methods with which to
                              # attempt authentication. We have to define this later.
                              strategies: [:password,:token],
                              # The action is a route to send the user to when
                              # warden.authenticate! returns a false answer. We'll show
                              # this route below.
                              action: '/unauthenticated'
        # When a user tries to log in and cannot, this specifies the
        # app to send the user to.
        config.failure_app = self
    end

    Warden::Manager.before_failure do |env, _opts|
        # Because authentication failure can happen on any request but
        # we handle it only under "post '/auth/unauthenticated'", we need
        # to change request to POST
        env['REQUEST_METHOD'] = 'POST'
        # And we need to do the following to work with  Rack::MethodOverride
        env.each do |key, _value|
            env[key]['_method'] = 'post' if key == 'rack.request.form_hash'
        end
    end
    Warden::Strategies.add(:password) do
        def valid?
            params['user'] && params['user']['username'] && params['user']['password']
        end

        def authenticate!
            user = User.find_by(username: params['user']['username'])
            if user.nil?
                throw(:warden, message: 'The username you entered does not exist.')
            elsif user.authenticate(params['user']['password'])
                if params['user']['rememberme'] == "on"
                  token = user.create_token
                  series_identifier = user.create_series_identifier
                  user.save_series_identifier(series_identifier)
                  user.save_token(token)
                end
                success!(user)
            else
                throw(:warden, message: 'The username and password combination ')
            end
        end
    end

    Warden::Strategies.add(:token) do
        def authenticate!
            user = User.find_by(username: request.cookies['username'])
            if user.nil?
                throw(:warden, message: 'The username does not exist.')
            elsif user.token_authenticate(request.cookies['token'],request.cookies['series_identifier'])
                success!(user)
                token = user.create_token
                user.save_token(token)
            else
                throw(:warden, message: 'Token has problem.')
            end
        end
    end

    def warden_handler
      env['warden']
    end

    def check_authentication
      unless warden_handler.authenticated?
         flash[:error] = 'You must log in'
         redirect "/"
      end
    end

    def current_user
      warden_handler.user
    end

    def user_already_logged
        unless !warden_handler.authenticated?
          flash[:success] = "Welcome back #{current_user.username} !"
          redirect "/dashboard/#{current_user.id}"
        end
        unless request.cookies['token'].nil? and request.cookies['username'].nil?
          warden_handler.authenticate!(:token)
          if session[:return_to].nil?
              flash[:success] = "Welcome back #{current_user.username} !"
              response.set_cookie('token', { :value => current_user.session_hashed, :path => request.path, :expires => Time.now + (60 * 60 * 24 * 30),:httponly => true })
              redirect "/dashboard/#{current_user.id}"
          else
              redirect session[:return_to]
          end
        end
    end

    post '/' do
        warden_handler.authenticate!(:password)
        flash[:success] = 'Successfully logged in'
        if session[:return_to].nil?
            if params[:user][:rememberme] == "on"
              response.set_cookie('token', { :value => current_user.session_hashed, :path => request.path, :expires => Time.now + (60 * 60 * 24 * 30), :httponly => true })
              response.set_cookie('series_identifier', { :value => current_user.series_identifier, :path => request.path, :expires => Time.now + (60 * 60 * 24 * 30),:httponly => true })
              response.set_cookie('username', { :value => current_user.username, :path => request.path, :expires => Time.now + (60 * 60 * 24 * 30), :httponly => true })
            end
            redirect "/dashboard/#{current_user.id}"
        else
            redirect session[:return_to]
        end
    end

    get '/logout' do
        env['warden'].raw_session.inspect
        env['warden'].logout
        response.delete_cookie "token"
        response.delete_cookie "series_identifier"
        response.delete_cookie "username"
        flash[:success] = 'Successfully logged out'
        redirect '/'
    end

    post '/unauthenticated' do
        session[:return_to] = env['warden.options'][:attempted_path] if session[:return_to].nil?
        # Set the error and use a fallback if the message is not defined
        flash[:error] = env['warden.options'][:message] || 'You must log in'
        redirect '/'
    end
end
