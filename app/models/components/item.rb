class Item < Menu
    def initialize
        @title = "Sample title"
        @subtitle = "Sample subtitle"
        @readmode = false
        @icon = nil
    end

    def setTitle (title, data)
        @title = title
    end

    def setSubTitle (subtitle,data)
        @subtitle = subtitle
    end

    def setReadMode(readmode)
        @readmode = readmode
    end

    def setIcon(icon)
        @icon = icon
    end

    def getTitle()
        return @title
    end

    def getSubTitle()
        return @subtitle
    end

    def getReadMode()
        return @readmode
    end

    def getIcon()
        return @icon
    end

end