class MyApp < Sinatra::Base
## Dashboard main route
  get '/dashboard/:id' do
      check_authentication
      @dashboard = Dashboard.new
      @controller_name = @dashboard.controller_name
      @user = User.find(params['id'])
      if @user.id != current_user.id
        redirect "/dashboard/#{current_user.id}"
      else
        session_hashed = Base64.encode64(@user.id.to_s)
        @user.assign_attributes(
          session_hashed: session_hashed.to_s
        )
        @user.save
      end
      erb :"users/menu/dashboard",:layout => :'layouts/layout_online'
  end
## end Dashboard main route
end
