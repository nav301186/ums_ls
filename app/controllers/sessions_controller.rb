class SessionsController < Devise::SessionsController
  prepend_before_filter :require_no_authentication, :only => [:create]

  respond_to :json


 def create
      resource =  User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
      return invalid_login_attempt unless resource

        sign_in("user", resource)
        render :json=> {:success=>true, :email=>resource.email}
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