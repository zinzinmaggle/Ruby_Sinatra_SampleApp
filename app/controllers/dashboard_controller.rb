class Dashboard
  attr_accessor :controller_name
    def initialize(controller_name = 'dashboard')
        @controller_name = controller_name
    end
end
