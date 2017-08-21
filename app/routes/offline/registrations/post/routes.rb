class MyApp < Sinatra::Base
  include Recaptcha::Verify
  post '/register' do
      user = User.find_by(username: params['user']['username']).nil?
      if params[:user][:password] != "" && params[:user][:password] == params[:user][:rpassword] && user && verify_recaptcha
        @user = User.new
        @user.assign_attributes(
            username: params[:user][:username],
            password: BCrypt::Password.create(params[:user][:password]),
            session_hashed: ''
        )
        @user.save
        flash[:success] = 'Successfully signed-up !'
        redirect '/'
      elsif params[:user][:password] != params[:user][:rpassword]
        flash[:error] = 'Passwords does not match.'
      elsif params[:user][:username] == "" or /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i.match(params[:user][:username]).nil?
        flash[:error] = 'Please enter a valid e-mail address.'
      elsif !user
        flash[:error] = 'This e-mail is already taken !'
      elsif !verify_recaptcha
        flash[:error] = 'Captcha is required !'
      else
        flash[:error] = 'Please verify the form.'
      end
      redirect '/register'
  end
  post '/forgotpassword' do
    user = User.find_by(username: params['user']['username'])
    if params[:user][:username] == "" or /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i.match(params[:user][:username]).nil?
      flash[:error] = 'Please enter a valid e-mail address.'
    elsif user.nil?
      flash[:error] = 'There is no user with this e-mail !'
    else
      storable_string = user.password.to_s
      restored_hash = BCrypt::Password.new(storable_string)
      Pony.mail({
        :to => params[:user][:username],
        :from => 'frederic-quemper@outlook.com',
        :via => :smtp,
        :via_options => {
          :address        => 'smtp-mail.outlook.com',
          :port           => '587',
          :user_name      => 'frederic-quemper@outlook.com',
          :password       => '!Azer7895877',
          :authentication => :login, # :plain, :login, :cram_md5, no auth by default
          :domain         => "localhost.localdomain" # the HELO domain provided by the client to the server
        },
        :subject => 'Your Password ...',
        :body => "Your password is  #{restored_hash}."
      })
      flash[:success] = 'An e-mail has been sent.'
    end
    redirect '/forgotpassword'
  end
end
