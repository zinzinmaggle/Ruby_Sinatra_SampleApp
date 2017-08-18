class MyApp < Sinatra::Base
## Settings > Save User Profile Settings
    post '/settings/:id/updateProfile' do
      check_authentication
      @user = User.find(params['id'])
      if @user.id != current_user.id
        redirect "/settings/#{current_user.id}"
      else
        user = User.find_by(username: params['user']['usernameOrEmail']).nil?
        if params[:profile][:name] == '' and params[:profile][:phone] == '' and params[:profile][:ZIPcode] == '' and params[:profile][:city] == '' and params[:user][:usernameOrEmail]  == ''
          flash[:error] = 'Nothing to update.'
        elsif /[0-9]*/.match(params[:profile][:phone]).nil? and params[:profile][:phone] != ''
          flash[:error] = 'Expected a valid phone number.'
        elsif /^\d{5}(?:[-\s]\d{4})?$/.match(params[:profile][:ZIPcode]).nil? and params[:profile][:ZIPcode] != ''
          flash[:error] = 'Expected a valid ZIP-code.'
        elsif !user && params['user']['usernameOrEmail'] != ''
          flash[:error] = 'This e-mail is already taken !'
        elsif /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i.match(params[:user][:usernameOrEmail]).nil? and params[:user][:usernameOrEmail] != ''
          flash[:error] = 'Expected a valid e-mail address.'
        else
          @profile = UserProfile.find_by_userid(current_user.id)
            if @profile.nil?
              @profile =  UserProfile.new
            end
            @profile.assign_attributes(
              name: (params[:profile][:name] != '') ? params[:profile][:name]  :  @profile.name || '',
              phone:  (params[:profile][:phone] != '') ? params[:profile][:phone] :   @profile.phone || '',
              ZIPcode: (params[:profile][:ZIPcode] != '') ? params[:profile][:ZIPcode] :   @profile.ZIPcode || '',
              city: (params[:profile][:city] != '') ? params[:profile][:city] :   @profile.city || '',
              userid: current_user.id
            )
            @user.assign_attributes(
                username: (params[:user][:usernameOrEmail] != '') ? params[:user][:usernameOrEmail] : @user.username
            )
            @profile.save
            @user.save
            flash[:success] = 'Profile successfully saved !'
        end
        redirect "/settings/#{current_user.id}"
      end
    end
    post '/settings/:id/updatePassword' do
      check_authentication
      @user = User.find(params['id'])
      if @user.id != current_user.id
        redirect "/settings/#{current_user.id}"
      else
        if params[:user][:newPassword] == '' || params[:user][:reNewPassword] == ''
          flash[:error] = 'Nothing to update.'
        elsif params[:user][:newPassword] != params[:user][:reNewPassword]
          flash[:error] = 'Passwords does\'nt match.'
        else
          @user.assign_attributes(
            password: BCrypt::Password.create(params[:user][:newPassword])
          )
          @user.save
          flash[:success] = 'Password successfully updated !'
        end
        redirect "/settings/#{current_user.id}"
      end
    end
## end Settings > Save User Profile Settings
## Settings > App Settings
    post '/settings/:id/setAppNotifications' do
      check_authentication
      @user = User.find(params['id'])
      if @user.id != current_user.id
        redirect "/settings/#{current_user.id}"
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
        @redirect2tab = 1
        redirect "/settings/#{current_user.id}"
      end
    end
## end Settings >  App Settings
end
