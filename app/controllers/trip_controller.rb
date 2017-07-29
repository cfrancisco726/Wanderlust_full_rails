class TripController < ApplicationController
  def new
    @trip = Trip.new
  end

  def show
    @flight_data = ResponseFlightData.find(params[:id])

    @client = GooglePlaces::Client.new("AIzaSyDi9KP9NPSx8sus_vV2AM_JHF407fAPjfU")

    @attractions = @client.spots_by_query("Vacation attractions by #{convert_airportcode_to_destination(@flight_data[:destination])}")

    @attraction_photo = @attractions
  end


  def google_place
    @flight_data = ResponseFlightData.find(params[:trip_id])
    @client = GooglePlaces::Client.new("AIzaSyDi9KP9NPSx8sus_vV2AM_JHF407fAPjfU")
    @attractions = @client.spots_by_query("#{params[:location]} by #{convert_airportcode_to_destination(@flight_data[:destination])}")
    @attraction_photo = @attractions
    render "google_place"
  end

  def index
    @cheapest_flights = ResponseFlightData.all
    # binding.pry
    render "trip_details"
  end

  # qpx api returns cheapest flights first, element 0 thus is the cheapest flight
  def parse_api_response(response)
    trips = []

    response["trips"]["tripOption"].each do |trip|
      flight_details = {}
      flight_details["saleTotal"]= trip["saleTotal"]
      flight_details["carrier"] = trip["slice"][0]["segment"][0]["flight"]["carrier"]
      flight_details["departure_time_when_leaving_home"] = trip["slice"][0]["segment"][0]["leg"][0]["departureTime"]
      flight_details["arrival_time_when_leaving_home"] = trip["slice"][0]["segment"][0]["leg"][0]["arrivalTime"]
      flight_details["departure_time_when_coming_home"] = trip["slice"][1]["segment"][0]["leg"][0]["departureTime"]
      flight_details["arrival_time_when_coming_home"] = trip["slice"][1]["segment"][0]["leg"][0]["arrivalTime"]
      flight_details["origin"] = trip["slice"][0]["segment"][0]["leg"][0]["origin"]
      flight_details["destination"] = trip["slice"][0]["segment"][0]["leg"][0]["destination"]
      trips << flight_details
    end
    trips
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

      AirportHelperTable.pluck(:airport_code).each do |airport_code|
        parsed_data = JSON.parse(FlightService
          .get_flights(trip_params.merge!(airport_code: airport_code)).body)
        if parsed_data["trips"]["tripOption"] != nil
          @array_flight = parse_api_response(parsed_data)
          @cheapest_flights << @array_flight[0]
        end
      end

      # ResponseFlightData.delete_all
      # ResponseFlightData.reset_pk_sequence

      @airports = []

      @cheapest_flights.each do |flight|
          flight_data = ResponseFlightData.create({ 
              saleTotal: flight["saleTotal"], 
              carrier: flight["carrier"], 
              arrival_time_when_leaving_home: flight["arrival_time_when_leaving_home"], 
              departure_time_when_leaving_home: flight["departure_time_when_leaving_home"], 
              arrival_time_when_coming_home: flight["arrival_time_when_coming_home"], 
              departure_time_when_coming_home: flight["departure_time_when_coming_home"], 
              origin: flight["origin"], 
              destination: flight["destination"] 
            })
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
