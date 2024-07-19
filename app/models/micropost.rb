class Micropost < ApplicationRecord
  PERMITTED_ATTRIBUTES = %i(content image).freeze
  belongs_to :user

  has_one_attached :image do |attach|
    attach.variant :display,
                   resize_to_limit: [Settings.digit_500, Settings.digit_500]
  end

  validates :content, presence: true, length: {maximum: Settings.digit_140}
  validates :image, content_type: {in: Settings.image_types,
                                   message:
                                   I18n.t("micropost.img_valid_format")},
                    size: {less_than: Settings.image_size.megabytes,
                           message: I18n.t("micropost.img_valid_size")}

  scope :newest, ->{order(created_at: :desc)}
end
