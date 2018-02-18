class Item < Menu
    def initialize
        @title = "Sample title"
        @subtitle = "Sample subtitle"
        @icon = nil
        @form = nil
        @readmode = true
        @isLastItem = false
    end

    def setTitle (title, data)
        @title = title
    end

    def setSubTitle (subtitle,data)
        @subtitle = subtitle
    end

    def setIcon(icon)
        @icon = icon
    end

    def setForm(form)
        @form = form
    end

    def setReadmode(readmode)
        @readmode = readmode
    end

    def setIsLastItem(isLastItem)
        @isLastItem = isLastItem
    end

    def getTitle()
        return @title
    end

    def getSubTitle()
        return @subtitle
    end

    def getIcon()
        return @icon
    end

    def getForm()
        return @form
    end

    def getReadmode()
        return @readmode
    end

    def getIsLastItem()
        return @isLastItem
    end

end