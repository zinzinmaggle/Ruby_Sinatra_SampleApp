class DataTables
    def initialize(colonne1,colonne2,applications,controller_name)
      @colonne1 = colonne1
      @colonne2 = colonne2
      @applications = applications
      @controller_name = controller_name
      @template = File.read("app/views/components/users/data_tables.erb")
    end
    def render()
      ERB.new(@template).result(binding)
    end
  def save(file)
    File.open(file, "w+") do |f|
      f.write(render)
    end
  end
end
