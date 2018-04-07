class Item
    def initialize
        @title = "Sample title"
        @subtitle = "Sample subtitle"
        @icon = nil
        @forms = nil
        @readmode = nil
        @fixture = nil
        @isLastItem = nil
        @redirect = nil
    end

    def setTitle (title)
        @title = title
    end

    def setFixture(fixture)
        @fixture = fixture
    end

    def setSubTitle (subtitle)
        @subtitle = subtitle
    end

    def setIcon(icon)
        @icon = icon
    end

    def setForms(form)
        @form = form
    end

    def setReadmode(readmode)
        @readmode = readmode
    end

    def setIsLastItem(isLastItem)
        @isLastItem = isLastItem
    end

    def setRedirect(redirect)
        @redirect = redirect
    end

    def getTitle()
        return @title
    end

    def getFixture()
        return @fixture
    end

    def getSubTitle()
        return @subtitle
    end

    def getIcon()
        return @icon
    end

    def getForms()
        return @form
    end

    def getReadmode()
        return @readmode
    end

    def getIsLastItem()
        return @isLastItem
    end

    def getRedirect()
        return @redirect
    end

end