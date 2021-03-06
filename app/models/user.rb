class User < ApplicationRecord
  has_many :trips
  has_many :hotels, through: :trips, foreign_key: "hotel_id"
  has_many :flights, through: :trips, source: :flights
  has_many :save_user_trips 

  has_secure_password
end
