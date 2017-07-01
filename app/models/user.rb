class User < ApplicationRecord
  has_many :trips
  has_many :hotels, through: :trips
  has_many :flights, through: :trips
  has_secure_password
end
