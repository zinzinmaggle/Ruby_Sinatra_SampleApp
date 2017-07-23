class Javascript
  attr_accessor :controller_name, :user_id
    def initialize(controller_name = 'Javascript',user_id)
        @controller_name = controller_name
        @data_table = DataTables.new('Application Name','Framework Used',ApplicationItem.where(userid:user_id ,category: @controller_name))
        @data_table.save(File.join('./app/views/users/pages/', 'javascript.erb'))
    end
    def save_data(data)
      @data = data
      puts output = @data
    end
end
