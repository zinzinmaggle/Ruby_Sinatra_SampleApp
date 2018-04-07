class Category
    def initialize
        @category_name = nil
        @items = []
    end

    def setCategoryName(category_name)
        @category_name = category_name
    end

    def getCategoryName()
        return @category_name 
    end

    def setItems(items)
    end
    
    def getItems()
        return @items
    end

end