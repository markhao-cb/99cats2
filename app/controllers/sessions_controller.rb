class SessionsController < ApplicationController
  def new
    render :new
  end

  def create
    @user = User.find_by_credentials(user_params[:user_name],user_params[:password])
    if @user
      login!(@user)
      redirect_to cats_url
    else
      flash[:errors] = "fraud!"
      redirect_to new_session_url
    end
  end

  def destroy
    current_user.reset_session_token!
    logout!
    redirect_to new_session_url
  end
end
