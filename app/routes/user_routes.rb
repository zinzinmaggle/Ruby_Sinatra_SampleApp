class MyApp < Sinatra::Base
## Dashboard main route
    get '/dashboard/:id' do
        check_authentication
        @dashboard = Dashboard.new
        @controller_name = @dashboard.controller_name
        @user = User.find(params['id'])
        if @user.id != current_user.id
          redirect "/dashboard/#{current_user.id}"
        end
        erb :"users/dashboard",:layout => :layout_online
    end
## end Dashboard main route
## Dashboard > Javascript Category main route
    get '/dashboard/:id/javascript' do
        check_authentication
        @user = User.find(params['id'])
        @javascript = Javascript.new(@user.id)
        @controller_name = @javascript.controller_name
        if @user.id != current_user.id
          redirect "/dashboard/#{current_user.id}/javascript"
        end
        erb :"users/pages/javascript",:layout => :layout_online
    end
## end Dashboard > Javascript Category main route
    # get '/dashboard/:id/ruby' do
    #     check_authentication
    #     @user = User.find(params['id'])
    #     if @user.id != current_user.id
    #       redirect "/dashboard/#{current_user.id}/ruby"
    #     end
    #     erb :"users/pages/ruby",:layout => :layout_online
    # end
    # get '/dashboard/:id/csharp' do
    #     check_authentication
    #     @user = User.find(params['id'])
    #     if @user.id != current_user.id
    #       redirect "/dashboard/#{current_user.id}/csharp"
    #     end
    #     erb :"users/pages/csharp",:layout => :layout_online
    # end
    # get '/dashboard/:id/python' do
    #     check_authentication
    #     @user = User.find(params['id'])
    #     if @user.id != current_user.id
    #       redirect "/dashboard/#{current_user.id}/python"
    #     end
    #     erb :"users/pages/python",:layout => :layout_online
    # end
## Dashboard > Javascript Category > save item route
    post '/dashboard/:id/javascript/save' do
        check_authentication
        @user = User.find(params['id'])
        @javascript = Javascript.new(@user.id)
        @controller_name = @javascript.controller_name
        if @user.id != current_user.id
          redirect "/dashboard/#{current_user.id}/javascript"
        end
        unless params[:dataTable][:column1field].nil? || params[:dataTable][:column2field].nil? || params[:dataTable][:column1field] == '' || params[:dataTable][:column2field] == '' || params[:dataTable][:column3field].nil?
            filename = params[:dataTable][:column3field][:filename]
            file = params[:dataTable][:column3field][:tempfile]
            ext = File.extname("#{filename}")
            if ext != '.png'
              flash[:error] = 'Please choose a valid file to upload.'
            else
              File.open("./public/img/#{filename}", 'wb') do |f|
                f.write(file.read)
              end
              @application = ApplicationItem.new
              @application.assign_attributes(
                  appname: params[:dataTable][:column1field],
                  appframework:  params[:dataTable][:column2field],
                  userid: current_user.id,
                  filename: filename,
                  category: @controller_name.downcase
              )
              @application.save
              flash[:success] = 'Successfully saved !'
            end
        else
          flash[:error] = 'Please fill the entire form.'
        end
        redirect "/dashboard/#{current_user.id}/javascript"
    end
## end Dashboard > Javascript Category > save item route
## Dashboard > Javascript Category > delete item route
    post '/dashboard/:id/javascript/delete' do
      check_authentication
      @user = User.find(params['id'])
      if @user.id != current_user.id
        redirect "/dashboard/#{current_user.id}/javascript"
      else
        unless params[:dataTable][:removevalue].nil?
          @application = ApplicationItem.find(params[:dataTable][:removevalue])
          if @application.userid != @user.id
            flash[:error] = 'Cannot delete a file that is not yours'
          else
            File.delete("./public/img/#{@application.filename}")
            @application.destroy
            flash[:success] = 'Successfully removed !'
          end
        else
          flash[:error] = 'An error has occured while removing.'
        end
      end
      redirect "/dashboard/#{current_user.id}/javascript"
    end
## end Dashboard > Javascript Category > delete item route
## Dashboard > Javascript Category > download item route
    post '/dashboard/:id/javascript/download' do
      check_authentication
      @user = User.find(params['id'])
      if @user.id != current_user.id
        redirect "/dashboard/#{current_user.id}/javascript"
      else
        unless params[:dataTable][:downloadvalue].nil?
          @application = ApplicationItem.find(params[:dataTable][:downloadvalue])
          if @application.userid != @user.id
            flash[:error] = 'Can\'t download file that isn\'t yours'
          else
            send_file("./public/img/#{@application.filename}")
          end
        else
          flash[:error] = 'An error has occured while downloading.'
        end
      end
    end
## end Dashboard > Javascript Category > download item route
## Settings > Show Settings
    get '/settings/:id' do
      check_authentication
      @user = User.find(params['id'])
      if @user.id != current_user.id
        redirect "/settings/#{current_user.id}"
      else
        @tabs = true
        @tabArray = Array({:'1' => "User", :'2' => "App"})
        @settingsController = Settings.new(@user.id)
        @settings =  AppSetting.find_by_userid(current_user.id)
        @controller_name = @settingsController.controller_name
        @profile = UserProfile.find_by_userid(current_user.id)
      end
      erb :"users/settings",:layout => :layout_online
    end
## end Settings > Show Settings
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
          flash[:error] = 'This username is already taken !'
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
        redirect "/settings/#{current_user.id}"
      end
    end
## end Settings >  App Settings
end
