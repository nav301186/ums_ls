class SessionsController < Devise::SessionsController
  prepend_before_filter :require_no_authentication, :only => [:create]

  respond_to :json


 def create
      resource = User.find_for_database_authentication(:email => params[:user][:email])
      return invalid_login_attempt unless resource

      if resource.valid_password?(params[:user][:password])
        sign_in("user", resource)
        render :json=> {:success=>true, :email=>resource.email}
      return
      end
      invalid_login_attempt
  end

  def destroy
  	sign_out(@user)
  end

  protected
  def invalid_login_attempt
  	warden.custom_failure!
  	render json: {
  		:success=>false
  	}, status: 401
  end
  
end