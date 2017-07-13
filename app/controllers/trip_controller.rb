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

  # def google_hotels
  #   @flight_data = ResponseFlightData.find(params[:trip_id])
  #
  #   @client = GooglePlaces::Client.new("AIzaSyC6QVsR2_7tYbCiMCIWqEwg_6_EV6XHBIE")
  #
  #   @hotel_details = @client.spots_by_query("#{params[:location]} by #{convert_airportcode_to_destination(@flight_data[:destination])}", :types => ['hotel'], :exclude => ['cafe', 'establishment')
  #
  #   @attraction_photo = @attractions
  #
  #   render "google_place"
  # end

  def index
    @cheapest_flights = ResponseFlightData.all
    # binding.pry
    render "trip_details"
  end

  def create

    # render_to_string :partial => "trip/foo_bar"


    @trip = Trip.new(trip_params)
    origin = trip_params[:origin]
    departure_date = trip_params[:departure_date]
    arrival_date = trip_params[:arrival_date]
    passengers = trip_params[:passengers]
    budget = trip_params[:budget]

    if !@trip.validate_dates.empty?
      @errors = @trip.validate_dates
      render 'new'
    else

      @cheapest_flights = []
      #
      #
      ['DEN','LAX', 'MIA', 'FCO', 'LHR'].each do |airport_code|
        parsed_data_den = JSON.parse(api_call(req_body(origin, departure_date, arrival_date, passengers, budget, airport_code)).body)
        @array_flight= parse_api_response(parsed_data_den)
        @flight = @array_flight[0]
        @cheapest_flights << @flight
      end


      ResponseFlightData.delete_all
      ResponseFlightData.reset_pk_sequence

      @airports = []

      @cheapest_flights.each do |flight|
          flight_data = ResponseFlightData.new({saleTotal: flight["saleTotal"], carrier: flight["carrier"], arrival_time_when_leaving_home: flight["arrival_time_when_leaving_home"], departure_time_when_leaving_home: flight["departure_time_when_leaving_home"], arrival_time_when_coming_home: flight["arrival_time_when_coming_home"], departure_time_when_coming_home: flight["departure_time_when_coming_home"], origin: flight["origin"], destination: flight["destination"]})
          flight_data.save
          @airports << AirportHelperTable.find_by(airport_code: flight_data.destination)
      end



      @hash = Gmaps4rails.build_markers(@airports) do |airport, marker|

        marker.lat(airport.latitude)
        marker.lng(airport.longitude)

        flight = @cheapest_flights.find {|flight| flight["destination"] == airport.airport_code }
        index = @cheapest_flights.find_index(flight)
        marker.infowindow render_to_string(:partial => "/trip/flight_details", locals: { flight: flight, index: index})
        marker.picture({
                    :url => airport.image_url,
                    :width   => 32,
                    :height  => 32
                   })

      end

      render "trip_details"
    end
  end



  private

  def trip_params
    params.require(:trip).permit(:budget, :origin, :departure_date, :arrival_date, :passengers)
  end
end
