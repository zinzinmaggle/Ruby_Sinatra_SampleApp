class User_Profile
  def initialize(controller_name = 'Profile',user_id,parent_controller_name,option)
    $controller_name = controller_name
    $previous_link = "/"+ parent_controller_name +"/"+user_id.to_s+((!option.nil?) ? "/"+option : "")
  end

  def get_controller_name
      return $controller_name
  end

  def get_previous_link
      return $previous_link
  end

  def menu(user_id)
      menu = Menu.new(user_id)
      return menu.menu_user_profile
  end

  def editMenu(user_id,fromAction)
    menu = Menu.new(user_id)
    return menu.menu_user_profile_edit(fromAction)
  end
end