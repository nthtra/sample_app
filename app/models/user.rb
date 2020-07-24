class User < ApplicationRecord
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze

  validates :name, presence: true, 
    length: {maximum: Settings.validations.user.name.max_length}
  validates :email, presence: true, 
    length: {maximum: Settings.validations.user.email.max_length},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: true
  validates :password, presence: true, 
    length: {minimum: Settings.validations.user.password.min_length}

  before_save :downcase_email

  has_secure_password

  private

    def downcase_email
      email.downcase!
    end
end
