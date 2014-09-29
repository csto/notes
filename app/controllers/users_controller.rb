class UsersController < ApplicationController
  
  def update
    @user = User.find(params[:id])
    @user.update_attributes(permitted_params)
    respond_with @user
  end

  def destroy
  end
  
  private
  
  def permitted_params
    params.require(:user).permit(:email)
  end
  
end
