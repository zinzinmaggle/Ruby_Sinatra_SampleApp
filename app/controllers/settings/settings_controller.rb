class Settings
      attr_accessor: menu
      def initialize(controller_name="settings",route,property,action)
         $menu = Menu.new
         $menu.build(controller_name,route,property,action)
      end
  end