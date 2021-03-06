class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: :destroy
  def create
    if @micropost.save
      flash[:success] = t ".success"
      redirect_to root_url
    else
      @feed_items = current_user.microposts.page(params[:page])
                                .per Settings.pagination.feed_page
      flash.now[:danger] = t ".fail"
      render "static_pages/home"
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = t ".success"
    redirect_to request.referer || root_url
  end

  private

  def build_micropost
    @micropost = current_user.microposts.build micropost_params
  end

  def micropost_params
    params.require(:micropost).permit Micropost::MICROPOSTS_PARAMS
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    return unless @micropost

    redirect_to root_url
  end
end
