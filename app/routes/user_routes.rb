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
        @settings = Settings.new(@user.id)
        @controller_name = @settings.controller_name
      end
      erb :"settings/settings",:layout => :layout_online
    end
## end Settings > Show Settings
end
