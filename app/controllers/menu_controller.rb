class Menu
    def initialize(user_id)
       $user_id = user_id.to_s
       $user = User.find(user_id)
       $profile = UserProfile.find_by_userid(user_id)
    end

    def menu_settings
        return [
            {:categoryName => "General", :multipleInputs => false, :category => [{ :formType => "",:readMode => true, :title => "Notifications", :subtitle => "Manage notifications settings", :link => "/settings/"+$user_id.to_s+"/notifications"}]},
            {:categoryName => "User account", :multipleInputs => false,:category => [{ :formType => "",:readMode => true, :title => "Profile", :subtitle => "Manage your user profile" , :link => "/settings/"+$user_id.to_s+"/userProfile"},{:form => false, :formType => "",:readMode => true, :title => "Manage Password", :subtitle => "Manage your password", :link => "/settings/"+$user_id.to_s+"/managePassword"}]},
        ]
    end

    def menu_notifications
        return [
            {:categoryName => "General", :multipleInputs => false, :category => [{ :formType => "checkbox",:readMode => true, :title => "Enable Notifications", :subtitle => "Allow the application to send push notifications", :link => "/settings/"+$user_id.to_s+"/notifications/edit"}]},
        ]
    end

    def menu_user_profile
        return [
            {:categoryName => "Account", :multipleInputs => false, :category => [
                {:formType => "textfield", :readMode => true, :title => "E-mail address", :subtitle => $user.username, :link => "/settings/"+$user_id.to_s+"/userProfile/emailaddress/edit"}
            ]},
            {:categoryName => "Personnal", :multipleInputs => false, :category => [
                {:formType => "textfield", :readMode => true, :title => "First Name", :subtitle => "frederic-quemper@gmail.com", :link => "/settings/"+$user_id.to_s+"/userProfile/firstname/edit"},
                {:formType => "textfield",:readMode => true, :title => "Last Name", :subtitle => "frederic-quemper@gmail.com", :link => "/settings/"+$user_id.to_s+"/userProfile/lastname/edit"},
                {:formType => "textfield",:readMode => true, :title => "Phone", :subtitle => $profile.phone, :link => "/settings/"+$user_id.to_s+"/userProfile/phone/edit"},
                {:formType => "textfield",:readMode => true, :title => "Street Address", :subtitle => "frederic-quemper@gmail.com", :link => "/settings/"+$user_id.to_s+"/userProfile/address/edit"},
                {:formType => "textfield",:readMode => true, :title => "Zip-Code", :subtitle => $profile.ZIPcode, :link => "/settings/"+$user_id.to_s+"/userProfile/zipcode/edit"},
                {:formType => "textfield",:readMode => true, :title => "City", :subtitle => $profile.city, :link => "/settings/"+$user_id.to_s+"/userProfile/city/edit"}
            ]},
        ]
    end

    def menu_manage_password
        return [
            {:categoryName => "", :multipleInputs => true, :category => [
                { :form => [
                    {:inputName => "user[newPassword]", :inputLabel => "Enter your new password", :inputError => "", :inputId => "newPassword", :inputPattern => "", :inputType => "password"}
                ],
                 :formType => "textfield",:readMode => false, :title => "", :subtitle => "", :link => ""},
                { :form => [
                    {:inputName => "user[reNewPassword]", :inputLabel => "Re-type your new password", :inputError => "", :inputId => "reNewPassword", :inputPattern => "", :inputType => "password"}
                ],
                 :formType => "textfield",:readMode => false, :title => "", :subtitle => "", :link => ""}
            ]},
        ]
    end

    def menu_user_profile_edit(fromAction)
        case fromAction
            when "emailaddress"
                return [
                    {:categoryName => "", :multipleInputs => false, :category => [
                        { :form => [
                            {:inputName => "user[email]", :inputLabel => "Update your e-mail address", :inputError => "Expected a valid e-mail address", :inputId => "userEmail", :inputPattern => "^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}$", :inputType => "email"}
                        ],
                        :formType => "textfield",:readMode => false, :title => "", :subtitle => "", :link => ""}
                    ]}
                ]
            when "firstname"
                return [
                    {:categoryName => "", :multipleInputs => false, :category => [
                        { :form => [
                            {:inputName => "user[firstname]", :inputLabel => "Update your first name", :inputError => "Expected a valid first name", :inputId => "userFirstName", :inputPattern => "", :inputType => "text"}
                        ],
                        :formType => "textfield",:readMode => false, :title => "", :subtitle => "", :link => ""}
                    ]}
                ]
            when "lastname"
                return [
                    {:categoryName => "", :multipleInputs => false, :category => [
                        { :form => [
                            {:inputName => "user[lastname]", :inputLabel => "Update your last name", :inputError => "Expected a valid last name", :inputId => "userLastName", :inputPattern => "", :inputType => "text"}
                        ],
                        :formType => "textfield",:readMode => false, :title => "", :subtitle => "", :link => ""}
                    ]}
                ]
            when "phone"
                return [
                    {:categoryName => "", :multipleInputs => false, :category => [
                        { :form => [
                            {:inputName => "user[phone]", :inputLabel => "Update your phone number", :inputError => "Expected a valid phone number", :inputId => "userPhone", :inputPattern => "[0-9]*", :inputType => "phone"}
                        ],
                        :formType => "textfield",:readMode => false, :title => "", :subtitle => "", :link => ""}
                    ]}
                ]
            when "streetaddress"
                return [
                    {:categoryName => "", :multipleInputs => false, :category => [
                        { :form => [
                            {:inputName => "user[streetaddress]", :inputLabel => "Update your street address", :inputError => "Expected a valid street address", :inputId => "userStreetAddress", :inputPattern => "", :inputType => "text"}
                        ],
                        :formType => "textfield",:readMode => false, :title => "", :subtitle => "", :link => ""}
                    ]}
                ]
            when "zipcode"
                return [
                    {:categoryName => "", :multipleInputs => false, :category => [
                        { :form => [
                            {:inputName => "user[zipcode]", :inputLabel => "Update your zip-code", :inputError => "Expected a valid zip-code", :inputId => "userZipCode", :inputPattern => "^\d{5}(?:[-\s]\d{4})?$", :inputType => "text"}
                        ],
                        :formType => "textfield",:readMode => false, :title => "", :subtitle => "", :link => ""}
                    ]}
                ]
            when "city"
                return [
                    {:categoryName => "", :multipleInputs => false, :category => [
                        { :form => [
                            {:inputName => "user[city]", :inputLabel => "Update your city", :inputError => "Expected a valid city", :inputId => "userCity", :inputPattern => "", :inputType => "text"}
                        ],
                        :formType => "textfield",:readMode => false, :title => "", :subtitle => "", :link => ""}
                    ]}
                ]
        end
    end
end