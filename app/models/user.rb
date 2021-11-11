class User < ApplicationRecord
  include ActiveModel::Serializers::JSON
  has_secure_password

  enum role: %i[user admin].freeze

  validates :email,
            format: { with: URI::MailTo::EMAIL_REGEXP },
            presence: true,
            uniqueness: { case_sensitive: false }

  def attributes
    { id: id, email: email, role: role, username: username}
  end

  def generate_password_token!
    begin
      self.reset_password_token = SecureRandom.urlsafe_base64
    end while User.exists?(reset_password_token: self.reset_password_token)
    # lower this time
    self.reset_password_token_expires_at = 1.day.from_now
    save!
  end

  def generate_confirmation_token!
    begin
      self.signup_confirmation_token = SecureRandom.urlsafe_base64
    end while User.exists?(signup_confirmation_token: self.signup_confirmation_token)
    # lower this time
    self.signup_confirmation_token_expires_at = 1.day.from_now
    save!
  end

  def clear_password_token!
    self.reset_password_token = nil
    self.reset_password_token_expires_at = nil
    save!
  end

end
