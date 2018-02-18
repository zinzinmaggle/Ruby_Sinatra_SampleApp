class UserProfile < ActiveRecord::Base
 def initialize(pclass,row,userId)
    initRow(pclass,row,userId)
 end
 def initRow(pclass,row,userId)
    if (row.nil?)
        pclass.assign_attributes(
            userid: userId
          )
        pclass.save
    end
 end
end