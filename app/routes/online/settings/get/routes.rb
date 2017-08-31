class MyApp < Sinatra::Base
## Settings > Show Settings
  get '/settings/:id' do
    check_authentication
    @user = User.find(params['id'])
    if @user.id != current_user.id
      redirect "/settings/#{current_user.id}"
    else
      @tabs = true
      @tabArray = {'1'=>["","User","is-active"],'2'=>["/settings/#{@user.id}/appsettings","App",""]}
      @settingsController = Settings.new(@user.id)
      @controller_name = @settingsController.controller_name
      @profile = UserProfile.find_by_userid(current_user.id)
    end
    erb :"users/menu/settings/settings",:layout => :'layouts/layout_online'
  end
## end Settings > Show Settings
## Settings > Show AppSettings
  get '/settings/:id/appsettings' do
    check_authentication
    @user = User.find(params['id'])
    if @user.id != current_user.id
      redirect "/settings/#{current_user.id}"
    else
      @tabs = true
      @tabArray = {'1'=>["/settings/#{@user.id}","User",""],'2'=>["","App","is-active"]}
      @settingsController = Settings.new(@user.id)
      @controller_name = @settingsController.controller_name
      @settings =  AppSetting.find_by_userid(current_user.id)

    end
    erb :"users/menu/settings/appsettings",:layout => :'layouts/layout_online'
  end
## end Settings > Show Settings
end
