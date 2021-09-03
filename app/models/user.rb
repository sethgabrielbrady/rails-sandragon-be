class User < ApplicationRecord
  has_secure_password

  enum role: %i[user manager admin].freeze

end
