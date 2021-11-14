class User < ApplicationRecord
  include ActiveModel::Serializers::JSON
  has_secure_password

  enum role: %i[user admin].freeze

  validates :password, :email, :username, presence: true

  validates :email,
            format: { with: URI::MailTo::EMAIL_REGEXP },
            uniqueness: { case_sensitive: false }

  USERNAME_FORMAT = /\A(?=.{2,20}\z)[a-zA-Z0-9]+(?:[._][a-zA-Z0-9]+)*\z/

  validates :username,  format: { with: USERNAME_FORMAT },
            uniqueness: true

  PASSWORD_FORMAT = /\A
    (?=.{8,})          # Must contain 8 or more characters
    (?=.*\d)           # Must contain a digit
    (?=.*[a-z])        # Must contain a lower case character
    (?=.*[A-Z])        # Must contain an upper case character
    (?=.*[[:^alnum:]]) # Must contain a symbol
  /x

  validates :password, format: { with: PASSWORD_FORMAT }

  # validates :terms_of_service, acceptance: true
  # validates :receive_emails, inclusion: { in: [true, false]  } #for email inclusion


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

  def clear_password_token!
    self.reset_password_token = nil
    self.reset_password_token_expires_at = nil
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

  def clear_signup_confirmation_token!
    self.signup_confirmation = nil
    self.signup_confirmation_expires_at = nil
    save!
  end

end
