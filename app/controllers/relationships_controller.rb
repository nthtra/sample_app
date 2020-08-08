class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    @user = User.find_by id: params[:followed_id]
    if @user.blank?
      flash[:danger] = t ".user_not_exist"
      redirect_to root_path
    else
      current_user.follow @user
      respond_to do |format|
        format.html{redirect_to @user}
        format.js
      end
    end
  end

  def destroy
    @user = Relationship.find_by(id: params[:id]).followed
    if @user.blank?
      flash[:danger] = t ".user_not_exist"
      redirect_to root_path
    else
      current_user.unfollow @user
      redirect_to user
      respond_to do |format|
        format.html{redirect_to @user}
        format.js
      end
    end
  end
end
