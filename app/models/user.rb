class User < ApplicationRecord
  has_many :trips
  has_many :hotels, through: :trips, foreign_key: "hotel_id"
  has_many :flights, through: :trips, foreign_key: "flight_id"
  has_secure_password
end
