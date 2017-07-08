class TripController < ApplicationController
  def new
    @trip = Trip.new
  end

  def create
    @trip = Trip.new(trip_params)
    origin = trip_params[:origin]
    departure_date = trip_params[:departure_date]
    arrival_date = trip_params[:arrival_date]
    passengers = trip_params[:passengers]
    budget = trip_params[:budget]
    parsed_data = JSON.parse(api_call(req_body(origin, departure_date, arrival_date, passengers, budget)).body)

    array_flights = parse_api_response(parsed_data)



    binding.pry

  end

  private

  def trip_params
    params.require(:trip).permit(:budget, :origin, :departure_date, :arrival_date, :passengers)
  end
end
