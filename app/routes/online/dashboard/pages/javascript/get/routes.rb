class MyApp < Sinatra::Base
## Dashboard > Javascript Category main route
  get '/dashboard/:id/javascript' do
      check_authentication
      @user = User.find(params['id'])
      @javascript = Javascript.new(@user.id)
      @controller_name = @javascript.controller_name
      if @user.id != current_user.id
        redirect "/dashboard/#{current_user.id}/javascript"
      end
      erb :"users/pages/javascript",:layout => :'layouts/layout_online'
  end
## end Dashboard > Javascript Category main route
end
