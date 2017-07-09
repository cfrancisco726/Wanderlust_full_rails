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
    parsed_data_den = JSON.parse(api_call(req_body_den(origin, departure_date, arrival_date, passengers, budget)).body)
    @array_flights_den = parse_api_response(parsed_data_den)
    parsed_data_den = JSON.parse(api_call(req_body_den(origin, departure_date, arrival_date, passengers, budget)).body)

    cheapest_flights = []
    binding.pry
    # @array_flights.each do |flight|
    #   while cheapest_flights.
    # end

    render "trip_details"
  end

  private

  def trip_params
    params.require(:trip).permit(:budget, :origin, :departure_date, :arrival_date, :passengers)
  end
end
