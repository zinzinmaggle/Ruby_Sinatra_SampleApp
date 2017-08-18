class MyApp < Sinatra::Base
  include Recaptcha::ClientHelper
  get '/' do
    user_already_logged
    @timeout = 0
    erb :index, :layout => :'layouts/layout_offline'
  end

  get '/register' do
    user_already_logged
    @timeout = 850
    erb :'registrations/signup', :layout => :'layouts/layout_offline'
  end

  get  '/forgotpassword' do
      user_already_logged
      erb :'registrations/forgotpassword', :layout => :'layouts/layout_offline'
  end

end
