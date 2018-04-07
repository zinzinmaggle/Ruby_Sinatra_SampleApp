class MyApp < Sinatra::Base
## Settings > Update
  get '/settings/:id/?:route?/?:property?/?:action?' do
    check_authentication
    user = User.find(params['id'])
    $route = params['route']
    $property = params['property']
    $action = params['action']
    if user.id != current_user.id
      redirect "/settings/#{current_user.id}"
    else
      $setting = Settings.new($route,$property,$action)
      @menu = $setting.menu
      # if(!$route && !$property && !$action)

        # @menu.setTitle("Settings")
        # @menu.setForwardLink("/dashboard/#{current_user.id}", true, nil)
        # @menu.addCategory("About Ya")
        # @menu.addItem("Profile" , "Manage your user profile", nil, "About Ya", request.url+"/userprofile",false)
        # @menu.addItem("Account" , "Manage your user account", nil, "About Ya", request.url+"/manageaccount", true)
        # @menu.addCategory("Application Settings")
        # @menu.addItem("Notifications" , "Manage your notifications settings", nil, "Application Settings", request.url+"/appsettings",true)

      # elsif ($route && !$property && !$action)
        # @menu.setTitle(@menu.getRouteInformation("settings",$route,nil,"title"))
        # @menu.setForwardLink(request.url, false, 0)
        # @menu.addCategory(nil)
        # @menu.getInformations("settings",$route).each() do |(key,information), index|
        #     $class = index["table"].constantize.new($class,(index["table"].constantize).find_by(index["findby"] => current_user.id),current_user.id)
        #     if index['readmode'] === false
        #       @menu.addFormItem("settings",$route, index["item_name"],"form", request.url)
        #     else
        #       @menu.addItem(index["label"] , (index["table"].constantize).find_by(index["findby"] => current_user.id)[index["property"]] , index["icon"], nil, request.url+"/"+ index["property"]+"/"+index["action"],false)
        #     end
        # end
      # else
        # @menu.setActionButton(true)
        # @menu.setTitle(@menu.getRouteInformation("settings",$route,$property,"title"))
        # @menu.setForwardLink(request.url, false, 1)
        # @menu.addCategory(nil)
        # @menu.addFormItem("settings",$route,$property,"form", request.url)
      # end     
    end
      erb :"components/app/menu", :layout => :'layouts/layout_online_menu' 
  end
## End Settings > Update


end
