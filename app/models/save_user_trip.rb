class SaveUserTrip < ApplicationRecord
  belongs_to :user

  def image_url
    AirportHelperTable.find_by(airport_code: self.destination).image_url
  end
end
