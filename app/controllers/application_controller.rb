class ApplicationController < ActionController::Base
  include SessionsHelper
  before_action :set_locale

  protect_from_forgery with: :exception

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "users.new.login"
    redirect_to login_url
  end

  def find_user_by_id
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "users.user.user_not_found"
    redirect_to root_url
  end
end
