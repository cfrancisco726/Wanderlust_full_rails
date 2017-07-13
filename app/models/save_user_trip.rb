class SaveUserTrip < ApplicationRecord
  belongs_to :user
  validates_uniqueness_of :user_id, :scope => :destination

  def image_url
    AirportHelperTable.find_by(airport_code: self.destination).image_url
  end
end
