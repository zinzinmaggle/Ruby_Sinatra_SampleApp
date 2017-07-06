class MyApp < Sinatra::Base
    get '/dashboard/:id' do
        check_authentication
        @dashboard = Dashboard.new
        @controller_name = @dashboard.controller_name
        @user = User.find(params['id'])
        if @user.id != current_user.id
          redirect "/dashboard/#{current_user.id}"
        end
        erb :"users/dashboard",:layout => :layout_online
    end
    get '/dashboard/:id/javascript' do
        check_authentication
        @user = User.find(params['id'])
        if @user.id != current_user.id
          redirect "/dashboard/#{current_user.id}/javascript"
        end
        erb :"users/pages/javascript",:layout => :layout_online
    end
    get '/dashboard/:id/ruby' do
        check_authentication
        @user = User.find(params['id'])
        if @user.id != current_user.id
          redirect "/dashboard/#{current_user.id}/ruby"
        end
        erb :"users/pages/ruby",:layout => :layout_online
    end
    get '/dashboard/:id/csharp' do
        check_authentication
        @user = User.find(params['id'])
        if @user.id != current_user.id
          redirect "/dashboard/#{current_user.id}/csharp"
        end
        erb :"users/pages/csharp",:layout => :layout_online
    end
    get '/dashboard/:id/python' do
        check_authentication
        @user = User.find(params['id'])
        if @user.id != current_user.id
          redirect "/dashboard/#{current_user.id}/python"
        end
        erb :"users/pages/python",:layout => :layout_online
    end
end
