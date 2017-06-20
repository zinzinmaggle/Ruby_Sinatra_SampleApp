class MyApp < Sinatra::Base
    get '/dashboard/:id' do
        check_authentication
        @user = User.find(params['id'])
        if @user.id != current_user.id
          redirect "/dashboard/#{current_user.id}"
        end
        erb :"users/dashboard",:layout => :layout_online
    end
end
