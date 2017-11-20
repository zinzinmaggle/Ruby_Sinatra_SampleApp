class MyApp < Sinatra::Base
  ## Settings > Save User Profile
  post '/settings/:id/userprofile/:action/save' do
    check_authentication
    $user = User.find(params['id'])
    if $user.id != current_user.id
      redirect "/settings/#{current_user.id}"
    else
      
      redirect "/settings/#{current_user.id}"
    end
  end
  ## End Settings > Save User Profile 
  ## Settings > Save User Profile > firstname
  post '/settings/:id/userprofile/firstname/save' do
    check_authentication
    $user = User.find(params['id'])
    if $user.id != current_user.id
      redirect "/settings/#{current_user.id}"
    else
      
      redirect "/settings/#{current_user.id}"
    end
  end
  ## End Settings > Save User Profile > firstname
  ## Settings > Save User Profile > lastname
  post '/settings/:id/userprofile/lastname/save' do
    check_authentication
    $user = User.find(params['id'])
    if $user.id != current_user.id
      redirect "/settings/#{current_user.id}"
    else
      
      redirect "/settings/#{current_user.id}"
    end
  end
  ## End Settings > Save User Profile > lastname
  ## Settings > Save User Profile > phone
  post '/settings/:id/userprofile/phone/save' do
    check_authentication
    $user = User.find(params['id'])
    if $user.id != current_user.id
      redirect "/settings/#{current_user.id}"
    else
      
      redirect "/settings/#{current_user.id}"
    end
  end
  ## End Settings > Save User Profile > phone
  ## Settings > Save User Profile > streetaddress
  post '/settings/:id/userprofile/streetaddress/save' do
    check_authentication
    $user = User.find(params['id'])
    if $user.id != current_user.id
      redirect "/settings/#{current_user.id}"
    else
      
      redirect "/settings/#{current_user.id}"
    end
  end
  ## End Settings > Save User Profile > streetaddress
  ## Settings > Save User Profile > zipcode
  post '/settings/:id/userprofile/zipcode/save' do
    check_authentication
    $user = User.find(params['id'])
    if $user.id != current_user.id
      redirect "/settings/#{current_user.id}"
    else
      
      redirect "/settings/#{current_user.id}"
    end
  end
  ## End Settings > Save User Profile > zipcode
  ## Settings > Save User Profile > city
  post '/settings/:id/userprofile/city/save' do
    check_authentication
    $user = User.find(params['id'])
    if $user.id != current_user.id
      redirect "/settings/#{current_user.id}"
    else
      
      redirect "/settings/#{current_user.id}"
    end
  end
  ## End Settings > Save User Profile > city
  
## Settings > Save User Profile Settings
    # post '/settings/:id/userprofile/' do
    #   check_authentication
    #   $user = User.find(params['id'])
    #   if $user.id != current_user.id
    #     redirect "/settings/#{current_user.id}"
    #   else
    #     user = User.find_by(username: params['user']['userEmail']).nil?
    #     if params[:profile][:name] == '' and params[:profile][:userPhone] == '' and params[:profile][:ZIPcode] == '' and params[:profile][:userCity] == '' and params[:user][:userEmail]  == ''
    #       flash[:error] = 'Nothing to update.'
    #     elsif /[0-9]*/.match(params[:profile][:userPhone]).nil? and params[:profile][:userPhone] != ''
    #       flash[:error] = 'Expected a valid phone number.'
    #     elsif /^\d{5}(?:[-\s]\d{4})?$/.match(params[:profile][:ZIPcode]).nil? and params[:profile][:ZIPcode] != ''
    #       flash[:error] = 'Expected a valid ZIP-code.'
    #     elsif !user && params['user']['usernameOrEmail'] != ''
    #       flash[:error] = 'This e-mail is already taken !'
    #     elsif /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i.match(params[:user][:userEmail]).nil? and params[:user][:userEmail] != ''
    #       flash[:error] = 'Expected a valid e-mail address.'
    #     else
    #       @profile = UserProfile.find_by_userid(current_user.id)
    #         if @profile.nil?
    #           @profile =  UserProfile.new
    #         end
    #         @profile.assign_attributes(
    #           name: (params[:profile][:name] != '') ? params[:profile][:name]  :  @profile.name || '',
    #           phone:  (params[:profile][:userPhone] != '') ? params[:profile][:userPhone] :   @profile.phone || '',
    #           ZIPcode: (params[:profile][:ZIPcode] != '') ? params[:profile][:ZIPcode] :   @profile.ZIPcode || '',
    #           city: (params[:profile][:userCity] != '') ? params[:profile][:userCity] :   @profile.city || '',
    #           userid: current_user.id
    #         )
    #         $user.assign_attributes(
    #             username: (params[:user][:userEmail] != '') ? params[:user][:userEmail] : $user.username
    #         )
    #         @profile.save
    #         $user.save
    #         flash[:success] = 'Profile successfully saved !'
    #     end
    #     redirect "/settings/#{current_user.id}"
    #   end
    # end
  ## End Settings > Save User Settings > password
  post '/settings/:id/managepassword/save' do
    check_authentication
    $user = User.find(params['id'])
    if $user.id != current_user.id
      redirect "/settings/#{current_user.id}"
    else
      if params[:user][:newPassword] == '' || params[:user][:reNewPassword] == ''
        flash[:error] = 'Nothing to update.'
      elsif params[:user][:newPassword] != params[:user][:reNewPassword]
        flash[:error] = 'Passwords does\'nt match.'
      else
        $user.assign_attributes(
          password: BCrypt::Password.create(params[:user][:newPassword])
        )
        $user.save
        flash[:success] = 'Password successfully updated !'
      end
      redirect "/settings/#{current_user.id}"
    end
  end
  ## End Settings > Save User Settings > password
  ## Settings >  Save App Settings > notifications > enable app notification
  post '/settings/:id/notifications/:notification/save' do
    check_authentication
    $user = User.find(params['id'])
    if $user.id != current_user.id
      redirect "/settings/#{current_user.id}/appsettings"
    elsif !params[:settings].nil? and (params[:settings][:appnotifications] != 'on')
      flash[:error] = 'Unexpected parameter.'
    else
      @settings = AppSetting.find_by(userid: current_user.id)
      if @settings.nil?
        @settings = AppSetting.new
      end
      @settings.assign_attributes(
        appnotifications: (params[:settings].nil?) ? 'off' : params[:settings][:appnotifications],
        userid: current_user.id
      )
      @settings.save
      flash[:success] = 'App settings updated !'
      redirect "/settings/#{current_user.id}/appsettings"
    end
  end
  ## End Settings >  Save App Settings > notifications > enable app notification
end
