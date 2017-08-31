class MyApp < Sinatra::Base
  include Recaptcha::Verify
  post '/register' do
      user = User.find_by(username: params['user']['username']).nil?
      if params[:user][:password] != "" && params[:user][:password] == params[:user][:rpassword] && user && verify_recaptcha
        @user = User.new
        @user.assign_attributes(
            username: params[:user][:username],
            password: BCrypt::Password.create(params[:user][:password]),
            session_hashed: '',
            series_identifier: ''
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
      np = user.generate_new_password
      user.save_new_password(np)
      user.send_mail_for_new_password(user,np)
      flash[:success] = 'An e-mail has been sent.'
    end
    redirect '/forgotpassword'
  end
end
