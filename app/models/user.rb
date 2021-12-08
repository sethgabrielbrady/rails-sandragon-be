class User < ApplicationRecord
  include ActiveModel::Serializers::JSON
  has_secure_password
  has_one_attached :image

  enum role: %i[user admin].freeze
  validates :password, :email, :username, presence: true, on: :create
  validates :email,
            format: { with: URI::MailTo::EMAIL_REGEXP },
            uniqueness: { case_sensitive: false }

  USERNAME_FORMAT = /\A(?=.{2,20}\z)[a-zA-Z0-9]+(?:[._][a-zA-Z0-9]+)*\z/
  validates :username,  format: { with: USERNAME_FORMAT },
            uniqueness: true, on: :create

  PASSWORD_FORMAT = /\A
    (?=.{8,})          # Must contain 8 or more characters
    (?=.*\d)           # Must contain a digit
    (?=.*[a-z])        # Must contain a lower case character
    (?=.*[A-Z])        # Must contain an upper case character
    (?=.*[[:^alnum:]]) # Must contain a symbol
  /x

  validates :password, format: { with: PASSWORD_FORMAT }, on: :create
  validates :terms_of_service, acceptance: true, on: :create
  validate :acceptable_image

  def attributes
    { id: id, email: email, role: role, username: username}
  end

  def generate_password_token!
    begin
      self.reset_password_token = SecureRandom.urlsafe_base64
    end while User.exists?(reset_password_token: self.reset_password_token)
    # lower this time
    self.reset_password_token_expires_at = 20.minutes.from_now
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
    self.signup_confirmation_token_expires_at = 20.minutes.from_now
    save!
  end

  def clear_signup_confirmation_token!
    self.signup_confirmation = nil
    self.signup_confirmation_expires_at = nil
    save!
  end

  def image_url
    image.attached? ? url_for(image) : nil
  end

  def falsify_any_active
    if self.active
        self.class.where('id != ? and active', self.id).update_all("active = 'false'")
    end
  end

  def acceptable_image
    return unless image.attached?

    unless image.byte_size <= 1.megabyte
      errors.add(:main_image, "is too big")
    end

    acceptable_types = ["image/jpeg", "image/png"]
    unless acceptable_types.include?(image.content_type)
      errors.add(:mage, "must be a JPEG or PNG")
    end
  end

end
