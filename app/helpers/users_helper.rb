module UsersHelper
  def gravatar_for user, options = {size: Settings.gravatar_size}
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end

  def can_destroy_user? user
    current_user.admin? && !current_user?(user)
  end

  def active_relationship_with user
    current_user.active_relationships.find_by(followed_id: user.id)
  end
end
