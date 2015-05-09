class RegistrationsController < Devise::RegistrationsController
  prepend_before_filter :require_no_authentication, :only => [:create]
  respond_to :json
  
  def create
    puts "============================================================"
    puts "registering new user"
    puts "============================================================"

    @user = User.new(sign_up_params)
    if @user.save
       puts "============================================================"
       puts "new user registered"
       puts "============================================================"

      render json: @user
      return
    else
      warden.custom_failure!
      render json: @user.errors, status: 422
    end
  end
  
  def update
    new_params = params.permit(:email, 
      :username, :current_password, :password,
      :password_confirmation)
    change_password = true

    if params[:user][:password].blank?
      params[:user].delete("password")
      params[:user].delete("password_confirmation")
      new_params = params.permit(:email, 
      :username)
        change_password= false
    end

    @user = User.find(current_user.id)
    is_valid = false

    if change_password
       is_valid = @user.update_with_password(new_params)
    else
      is_valid = @user.update_without_password(new_params)
    end

    if is_valid
      set_flash_message :notice, :updated
      sign_in @user, :bypass => true
      redirect_to after_update_path_for(@user)
    else
      render "edit"
    end
  end

  def destroy
    @user = User.find(current_user.email)
    @user.is_active = 0
    if @user.save
      sign_out @user
      redirect_to root_path
    else
      render "edit"
    end
  end

  def cancel
    puts "============================================================"
    puts current_user
    # puts params[:user][:email]
    puts "============================================================"

    @auser = User.find(current_user.id)
    @user.is_active = 0
    sign_out @user
    render :json=> {:success => true}
  end

  def sign_up_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

end
