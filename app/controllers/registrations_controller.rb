class RegistrationsController < Devise::RegistrationsController

  def create
    @new_user = User.new(user_param)
    if User.count.zero? then @new_user.admin = true end
    @new_user.save
    redirect_to root_path
  end

  def sign_up_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :current_password)
  end

  def user_param
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :current_password, :admin)
  end

end