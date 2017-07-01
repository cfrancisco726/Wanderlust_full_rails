class Trip < ApplicationRecord
  has_many :hotels
  has_many :flights
  belongs_to :user
end
