class TripController < ApplicationController
  def new
    @trip = Trip.new
  end

  def show
    @flight_data = ResponseFlightData.find(params[:id])
    @client = GooglePlaces::Client.new("AIzaSyAT1ZjcNRb6xCagpy01b97Uj-5b1oea3Ic")
    @attractions = @client.spots_by_query("Vacation attractions by #{convert_airportcode_to_destination(@flight_data[:destination])}")

    @attraction_photo = @attractions
  end

  def google_place
    @flight_data = ResponseFlightData.find(params[:trip_id])
    @client = GooglePlaces::Client.new("AIzaSyAT1ZjcNRb6xCagpy01b97Uj-5b1oea3Ic")
    @attractions = @client.spots_by_query("#{params[:location]} by #{convert_airportcode_to_destination(@flight_data[:destination])}")

    @attraction_photo = @attractions

    render "google_place"
  end

  def index
    # binding.pry
    @cheapest_flights = ResponseFlightData.all.each_slice(10).to_a
    render "trip_details"
  end

  def create

    @trip = Trip.new(trip_params)
    origin = trip_params[:origin]
    departure_date = trip_params[:departure_date]
    arrival_date = trip_params[:arrival_date]
    passengers = trip_params[:passengers]
    budget = trip_params[:budget]

    # @hash = Gmaps4rails.build_markers(@users) do |user, marker|
    # marker.lat user.latitude
    # marker.lng user.longitude
    # end
    @cheapest_flights = []

    ['DEN', 'LAX', 'MIA', 'FCO'].each do |airport_code|
      parsed_data_den = JSON.parse(api_call(req_body(origin, departure_date, arrival_date, passengers, budget, airport_code)).body)
      @array_flight= parse_api_response(parsed_data_den)
      @cheapest_flights << @array_flight
    end




      # @cheapest_flights = @array_flights_den + @array_flights_lax + @array_flights_mia

    ResponseFlightData.delete_all
    ResponseFlightData.reset_pk_sequence

    @cheapest_flights.flatten.each do |flight|

      flight_data = ResponseFlightData.new({saleTotal: flight["saleTotal"], carrier: flight["carrier"], arrival_time_when_leaving_home: flight["arrival_time_when_leaving_home"], departure_time_when_leaving_home: flight["departure_time_when_leaving_home"], arrival_time_when_coming_home: flight["arrival_time_when_coming_home"], departure_time_when_coming_home: flight["departure_time_when_coming_home"], origin: flight["origin"], destination: flight["destination"]})
      flight_data.save
    end
  
    render "trip_details"
  end



  private

  def trip_params
    params.require(:trip).permit(:budget, :origin, :departure_date, :arrival_date, :passengers)
  end
end
