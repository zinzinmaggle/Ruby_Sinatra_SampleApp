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
                              # "strategies" is an array of named methods with which to
                              # attempt authentication. We have to define this later.
                              strategies: [:password],
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
                success!(user)
            else
                throw(:warden, message: 'The username and password combination ')
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

    def user_already_logged
      if warden_handler.authenticated?
        redirect "/dashboard/#{current_user.id}"
      end
    end

    def current_user
      warden_handler.user
    end

    post '/' do
        warden_handler.authenticate!
        if session[:return_to].nil?
            redirect "/dashboard/#{current_user.id}"
        else
            redirect session[:return_to]
        end
    end

    get '/logout' do
        env['warden'].raw_session.inspect
        env['warden'].logout
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
