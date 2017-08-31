class MyApp < Sinatra::Base
## Dashboard main route
  get '/dashboard/:id' do
      check_authentication
      @dashboard = Dashboard.new
      @controller_name = @dashboard.controller_name
      @user = User.find(params['id'])
      if @user.id != current_user.id
        redirect "/dashboard/#{current_user.id}"
      end
      erb :"users/menu/dashboard/dashboard",:layout => :'layouts/layout_online'
  end
## end Dashboard main route
end
