class MyApp < Sinatra::Base
## Settings > Show Settings
  get '/settings/:id' do
    check_authentication
    @user = User.find(params['id'])
    if @user.id != current_user.id
      redirect "/settings/#{current_user.id}"
    else
      @tabs = true
      @tabArray = Array({:'1' => "User", :'2' => "App"})
      @settingsController = Settings.new(@user.id)
      @settings =  AppSetting.find_by_userid(current_user.id)
      @controller_name = @settingsController.controller_name
      @profile = UserProfile.find_by_userid(current_user.id)
    end
    erb :"users/menu/settings",:layout => :'layouts/layout_online'
  end
## end Settings > Show Settings
end
