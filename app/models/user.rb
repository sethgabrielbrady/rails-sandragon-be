class User < ApplicationRecord
  include ActiveModel::Serializers::JSON
  has_secure_password

  enum role: %i[user admin].freeze

  validates :email,
            format: { with: URI::MailTo::EMAIL_REGEXP },
            presence: true,
            uniqueness: { case_sensitive: false }

end
