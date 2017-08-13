class Settings
  attr_accessor :controller_name
    def initialize(controller_name = 'Settings',user_id)
        @controller_name = controller_name
    end
end
