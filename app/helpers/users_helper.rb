module UsersHelper
  def gravatar_for user, size: Settings.validations.user.avatar.size
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag gravatar_url, alt: user.name, class: "gravatar"
  end

  def followed_user user_id
    current_user.active_relationships.find_by(followed_id: @user.id)
  end
end
