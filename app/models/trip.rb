class Trip < ApplicationRecord
  has_many :hotels
  has_many :flights
  belongs_to :user

  def validate_dates
    # binding.pry
    errors = []
    if self.departure_date > self.arrival_date
      errors << "Departure date must be before arrival date"
    elsif self.departure_date < Date.today || self.arrival_date < Date.today
      errors << "Departure date and arrival date must be after today"
    end
    errors
  end
end
