class PasswordResetsController < ApplicationController
  before_action :find_user, :valid_user, :check_expiration, only: %i(edit update)

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "password_resets.sent_email_notification"
      redirect_to root_url
    else
      flash[:danger] = t "password_resets.email_not_found"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].blank?
      @user.errors.add(:password, t("password_resets.empty"))
      render :edit
    elsif @user.update user_params.merge reset_digest: nil
      log_in @user
      flash[:success] = t "password_resets.success"
      redirect_to @user
    else
      flash.now[:danger] = t "password_resets.fail"
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit User::RESET_PASSWORD_PARAMS
  end

  def find_user
    @user = User.find_by email: params[:email].downcase
    return if @user

    flash[:errors] = t "password_resets.flash"
    redirect_to new_password_reset_url
  end

  def valid_user
    unless @user&.activated? &&
           @user&.authenticated?(:reset, params[:id])
          
    flash[:danger] = t "password_resets.forbidden"   
    redirect_to root_url
    end
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t "password_resets.expired"
    redirect_to new_password_reset_url
  end
end
