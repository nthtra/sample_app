class Micropost < ApplicationRecord
  MICROPOSTS_PARAMS = %i(content picture).freeze

  belongs_to :user

  validates :user_id, presence: true
  validates :content, presence: true,
            length: {maximum: Settings.size.content_size}
  validate :picture_size

  mount_uploader :picture, PictureUploader

  scope :order_by_created_at_desc, ->{order created_at: :desc}
  scope :feed_by_user, ->(user_ids){where user_id: user_ids}

  private

  def picture_size
    return if picture.size <= Settings.image.size.megabytes

    errors.add(:picture, t(".size_too_big"))
  end
end
