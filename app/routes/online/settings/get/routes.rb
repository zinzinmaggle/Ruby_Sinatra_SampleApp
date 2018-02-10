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
      if(!$route && !$property && !$action)

        @menu = Menu.new
        @menu.setTitle("Settings")
        @menu.setForwardLink("/dashboard/#{current_user.id}", true, nil)
        @menu.addCategory("User Account")
        @menu.addItem(true, "Profile" , "Manage your user profile", nil, "User Account", request.url+"/userprofile")
        @menu.addItem(true, "Account" , "Manage your user account", nil, "User Account", request.url+"/manageaccount")
        @menu.addCategory("General")
        @menu.addItem(true, "Notifications" , "Manage your notifications settings", nil, "General", request.url+"/notifications")

      elsif ($route && !$property && !$action)
        @menu = Menu.new
        @menu.setTitle(@menu.getRouteInformation("settings",$route,"title",nil))
        @menu.setForwardLink(request.url, false, 0)
        @menu.addCategory(nil)
        @menu.getInformations("settings",$route).each() do |(key,information), index|
           information =  index
           if $route === 'notifications'
            @menu.addItem(false, information["label"] , (information["table"].constantize).find_by(information["findby"] => current_user.id)[information["property"]] , information["icon"], nil, request.url+"/"+ information["property"]+"/"+information["action"])
           else
            $class = (information["table"].constantize).new
            $class.initRow($class,(information["table"].constantize).find_by(information["findby"] => current_user.id),current_user.id)
            @menu.addItem(true, information["label"] , (information["table"].constantize).find_by(information["findby"] => current_user.id)[information["property"]] , information["icon"], nil, request.url+"/"+ information["property"]+"/"+information["action"])
           end
        end
      else
        @menu = Menu.new
        @menu.setActionButton(true)
        @menu.setTitle(@menu.getRouteInformation("settings",$route,"title",$property))
        @menu.setForwardLink(request.url, false, 1)
        @menu.addCategory(nil)
        @menu.addFormItem("settings",$route,"form",$property, request.url)
      end     
    end
      erb :"components/app/menu", :layout => :'layouts/layout_online_menu' 
  end
## End Settings > Update


end
