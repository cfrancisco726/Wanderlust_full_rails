class HotelController < ApplicationController
  def new
    @hotel = Hotel.new
  end

  def create
    @hotel = Hotel.new(trip_params)
  end
end
