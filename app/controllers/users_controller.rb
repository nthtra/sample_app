class UsersController < ApplicationController
  def show
    @user = User.find_by params[:id]
    return if @user

    flash[:danger] = t "users.new.flash"
    redirect_to root_path
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t "users.new.title"
      redirect_to @user
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit User::USERS_PARAMS
  end
end
