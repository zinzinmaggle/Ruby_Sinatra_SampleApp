class ManagePassword
  def initialize(controller_name = 'Manage password',user_id,parent_controller_name)
    $controller_name = controller_name
    $previous_link = "/"+ parent_controller_name +"/"+user_id.to_s
  end

  def get_controller_name
      return $controller_name
  end

  def get_previous_link
      return $previous_link
  end

  def menu(user_id)
      menu = Menu.new(user_id)
      return menu.menu_manage_password
  end

  
end