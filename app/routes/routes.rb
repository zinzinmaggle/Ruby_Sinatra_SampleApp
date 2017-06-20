class MyApp < Sinatra::Base
  get '/' do
    user_already_logged
    @controller_name = "index"
    erb :signin, :layout => :layout_offline
  end

  get '/register' do
    user_already_logged
    @controller_name = "register"
    erb :'registrations/signup', :layout => :layout_offline
  end

  post '/register' do
      user = User.find_by(username: params['user']['username']).nil?
      if params[:user][:password] != "" && params[:user][:password] == params[:user][:rpassword] && user
        @user = User.new
        @user.assign_attributes(
            username: params[:user][:username],
            password: BCrypt::Password.create(params[:user][:password])
        )
        @user.save
        flash[:success] = 'Successfully signed-up !'
        redirect '/'
      elsif params[:user][:password] != params[:user][:rpassword]
        flash[:error] = 'Passwords does\'nt match.'
      elsif params[:user][:username] == ""
        flash[:error] = 'Please choose a valid username.'
      elsif !user
        flash[:error] = 'This username is already taken !'
      else
        flash[:error] = 'Please verify the form.'
      end
      redirect '/register'
  end
end
