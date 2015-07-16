class UsersController < ApplicationController
  def new
    render :new
  end

  def create
    @user = User.new(user_name: user_params[:user_name])
    @user.password = user_params[:password]
    if @user.save
      login!(@user)
      redirect_to cats_url
    else
      flash[:errors] = @user.errors.full_messages
      redirect_to new_user_url
    end
  end
end
