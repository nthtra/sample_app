class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if authenticated_password? user
      is_activated? user
    else
      flash.now[:danger] = t ".danger"
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end

  private

  def authenticated_password? user
    user&.authenticate params[:session][:password]
  end

  def is_activated? user
    if user.activated?
      log_in user
      if params[:session][:remember_me] == Settings.form.checkbox
        remember user
      else
        forget user
      end
      flash[:success] = t ".success", username: user.name
      redirect_back_or user
    else
      flash[:warning] = t "users.activation.not_activated_account_notification"
      redirect_to root_url
    end
  end
end
