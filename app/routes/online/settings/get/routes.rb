class MyApp < Sinatra::Base
## Settings > Show Settings
  get '/settings/:id' do
    check_authentication
    user = User.find(params['id'])
    if user.id != current_user.id
      redirect "/settings/#{current_user.id}"
    else
      settings = Settings.new(user.id,"dashboard")
      @controller_name = settings.get_controller_name
      @previous_link = settings.get_previous_link 
      @menu = settings.menu(user.id)
      # @profile = UserProfile.find_by_userid(current_user.id)
    end
    erb :"components/app/menu", :layout => :'layouts/layout_online_menu' 
  end
## end Settings > Show Settings
## Settings > Show notifications
  get '/settings/:id/notifications' do
    check_authentication
    user = User.find(params['id'])
    if user.id != current_user.id
      redirect "/settings/#{current_user.id}"
    else
      notifications = Notifications.new(user.id,"settings")
      @controller_name = notifications.get_controller_name
      @previous_link = notifications.get_previous_link
      @menu = notifications.menu(user.id)
    end
    erb :"components/app/menu", :layout => :'layouts/layout_online_menu'
  end
## end Settings > Show notifications
## Settings > Show user profile
  get '/settings/:id/userprofile' do
    check_authentication
    user = User.find(params['id'])
    if user.id != current_user.id
      redirect "/settings/#{current_user.id}"
    else
      userProfile = User_Profile.new(user.id,"settings",nil)
      @controller_name = userProfile.get_controller_name
      @previous_link = userProfile.get_previous_link
      @menu = userProfile.menu(user.id)      
    end
    erb :"components/app/menu",:layout => :'layouts/layout_online_menu'
  end
  get '/settings/:id/userprofile/:fromAction/edit' do
    check_authentication
    user = User.find(params['id'])
    if user.id != current_user.id
      redirect "/settings/#{current_user.id}"
    else
      userProfile = User_Profile.new(user.id,"settings","userprofile")
      @controller_name = userProfile.get_controller_name
      @previous_link = userProfile.get_previous_link
      @menu = userProfile.editMenu(user.id,params['fromAction'])   
      @saveMode = true   
    end
    erb :"components/app/menu",:layout => :'layouts/layout_online_menu'
  end
## end Settings > Show user profile 
## Settings > Show manage password
  get '/settings/:id/managepassword' do
    check_authentication
    user = User.find(params['id'])
    if user.id != current_user.id
      redirect "/settings/#{current_user.id}"
    else
      managePassword = ManagePassword.new(user.id,"settings")
      @controller_name = managePassword.get_controller_name
      @previous_link = managePassword.get_previous_link
      @menu = managePassword.menu(user.id)
      @saveMode = true
    end
    erb :"components/app/menu",:layout => :'layouts/layout_online_menu'
  end
## end Settings > Show  manage password
end
