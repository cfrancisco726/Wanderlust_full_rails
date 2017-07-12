class TripController < ApplicationController
  def new
    @trip = Trip.new
  end

  def show
    @flight_data = ResponseFlightData.find(params[:id])

    @client = GooglePlaces::Client.new("AIzaSyC6QVsR2_7tYbCiMCIWqEwg_6_EV6XHBIE")

    @attractions = @client.spots_by_query("Vacation attractions by #{convert_airportcode_to_destination(@flight_data[:destination])}")

    @attraction_photo = @attractions
  end


  def google_place
    @flight_data = ResponseFlightData.find(params[:trip_id])

    @client = GooglePlaces::Client.new("AIzaSyC6QVsR2_7tYbCiMCIWqEwg_6_EV6XHBIE")

    @attractions = @client.spots_by_query("#{params[:location]} by #{convert_airportcode_to_destination(@flight_data[:destination])}")

    @attraction_photo = @attractions

    render "google_place"
  end

  def index
    @cheapest_flights = ResponseFlightData.all.each_slice(10).to_a
    @airports = []

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


    # parsed_data_den = JSON.parse(api_call(req_body_den(origin, departure_date, arrival_date, passengers, budget)).body)
    # @array_flights_den = parse_api_response(parsed_data_den)
    # parsed_data_lax = JSON.parse(api_call(req_body_lax(origin, departure_date, arrival_date, passengers, budget)).body)
    # @array_flights_lax = parse_api_response(parsed_data_lax)

    @cheapest_flights = []
    hotels =  [1,2,3,4]

    ['DEN', 'LAX', 'MIA', 'FCO'].each do |airport_code|
      parsed_data_den = JSON.parse(api_call(req_body(origin, departure_date, arrival_date, passengers, budget, airport_code)).body)
      @array_flight= parse_api_response(parsed_data_den)

      
      city = []
      @array_hotel = [3,4,5,6,7]
      city << @array_flight
      city << @array_hotel
      @cheapest_flights << city
    end

      # @cheapest_flights = @array_flights_den + @array_flights_lax + @array_flights_mia

    ResponseFlightData.delete_all
    ResponseFlightData.reset_pk_sequence

    @airports = []

    @cheapest_flights.each do |city|
      flights = city[0]
      flights.each do |flight|
        flight_data = ResponseFlightData.new({saleTotal: flight["saleTotal"], carrier: flight["carrier"], arrival_time_when_leaving_home: flight["arrival_time_when_leaving_home"], departure_time_when_leaving_home: flight["departure_time_when_leaving_home"], arrival_time_when_coming_home: flight["arrival_time_when_coming_home"], departure_time_when_coming_home: flight["departure_time_when_coming_home"], origin: flight["origin"], destination: flight["destination"]})
        flight_data.save
        @airports << AirportHelperTable.find_by(airport_code: flight_data.destination)
      end

      hotels = city[1]
      hotels.each do |hotel|
        p hotel
      end
    end

      binding.pry

    @hash = Gmaps4rails.build_markers(@airports) do |airport, marker|


      marker.lat(airport.latitude)
      marker.lng(airport.longitude)
      marker.infowindow airport.location

    end




    end


    render "trip_details"
  end



  private

  def trip_params
    params.require(:trip).permit(:budget, :origin, :departure_date, :arrival_date, :passengers)
  end
end
