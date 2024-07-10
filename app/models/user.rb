class User < ApplicationRecord
  before_save :downcase_email

  validates :name, presence: true, length: {maximum: Settings.max_length_name}
  validates :email, presence: true,
    length: {maximum: Settings.max_length_email},
    format: {with: Regexp.new(Settings.valid_email_regex)},
    uniqueness: true
  validates :password, presence: true,
    length: {minimum: Settings.min_length_password}

  has_secure_password

  private

  def downcase_email
    email.downcase!
  end
end
