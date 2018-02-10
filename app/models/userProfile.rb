class UserProfile < ActiveRecord::Base
 def initRow(pclass,row,userId)
    if (row.nil?)
        pclass.assign_attributes(
            userid: userId
          )
        pclass.save
    end
 end
end