class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :lat_long, :current_user, :logged_in?, :api_call, :parse_api_response, :convert_airportcode_to_destination, :flights_date, :hotel_query, :hotel_query


  def current_user
    @user = User.find_by(id: session[:user_id])
  end

  def logged_in?
    !!current_user
  end

  def req_body(origin, departure_date, arrival_date, passengers, budget, destination_airport_code)
    {"request": {
          "passengers": { "adultCount": passengers.to_i },
          "slice": [{
              "origin": origin,
              "destination": destination_airport_code,
              "date": departure_date,
              "maxStops": 0,
            },
            {
              "origin": destination_airport_code,
              "destination": origin,
              "date": arrival_date
            }
          ],
          "maxPrice": "USD#{budget}",
          "solutions": "1"
        }
      }
  end

  def req_body_lax(origin, departure_date, arrival_date, passengers, budget)
    {"request": {
          "passengers": { "adultCount": passengers.to_i },
          "slice": [{
              "origin": origin,
              "destination": ['LAX'],
              "date": departure_date,
              "maxStops": 0,
            },
            {
              "origin": ['LAX'],
              "destination": origin,
              "date": arrival_date
            }
          ],
          "maxPrice": "USD#{budget}",
          "solutions": "1"
        }
      }
  end

  def req_body_mia(origin, departure_date, arrival_date, passengers, budget)
    {"request": {
          "passengers": { "adultCount": passengers.to_i },
          "slice": [{
              "origin": origin,
              "destination": ['MIA'],
              "date": departure_date,
              "maxStops": 0,
            },
            {
              "origin": ['MIA'],
              "destination": origin,
              "date": arrival_date
            }
          ],
          "maxPrice": "USD#{budget}",
          "solutions": "10"
        }
      }
  end



  def api_call(body)

    RestClient.post 'https://www.googleapis.com/qpxExpress/v1/trips/search?key=AIzaSyCRc7Fubn68ipT_1TnO8GrpuaHbUHI2how',
    body.to_json, :content_type => :json
  end

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

  def flights_date(flight_time)
    DateTime.parse(flight_time).strftime("%a %b %w at  %H:%M %p")
  end

  def convert_airportcode_to_destination(airport_code)
    if airport_code == "DEN"
      "Denver"
    elsif airport_code == "LAX"
      "Los Angeles"
    elsif airport_code == "MIA"
      "Miami"
    elsif airport_code == "FCO"
      "Italy"
    elsif airport_code == "SYD"
      "Sydney"
    elsif airport_code == "LHR"
      "London"
    elsif airport_code == "CDG"
      "Paris"
    elsif airport_code == "PRG"
      "Prague"
    elsif airport_code == "DXB"
      "Dubai"
    elsif airport_code == "JTR"
      "Santorini"
    elsif airport_code == "HNL"
      "Honolulu"
    elsif airport_code == "DPS"
      "Bali"
    elsif airport_code == "YVR"
      "Vancouver"
    elsif airport_code == "HKT"
      "Phuket"
    elsif airport_code == "EAS"
      "San Sebastian"
    elsif airport_code == "PPT"
      "Tahiti"
    elsif airport_code == "FAT"
      "Yosemite"
    elsif airport_code == "SJO"
      "Costa Rica"
    elsif airport_code == "SLC"
      "Salt Lake City"
    elsif airport_code == "JAC"
      "Jackson Hole"
    end
  end

  def hotel_query(latitude, longitude, check_in, check_out, max_rate)
     base_url = "http://api.sandbox.amadeus.com/v1.2/hotels/search-circle?latitude=#{latitude}&longitude=#{longitude}&radius=50&check_in=#{check_in}&check_out=#{check_out}&chain=RT&cy=USD&number_of_results=10&max_rate=#{max_rate}&apikey=P9Xuv7e4586ThMfR3nHlkojwJCR7ZHfe"
     data = open(base_url).read
     response = JSON.parse(data, headers: true, header_converters: :symbol)
  end

  def hotels_parse_response(hotel_query)
   hotel_details = {}
       hotel_query.each do |key, value|
       value.each do |key1, value1|
         hotel_details["property name"] = key1["property_name"]
         hotel_details["longitude and latitude"] = key1["location"]
         hotel_details["room type"] = key1["room_type_code"]
         hotel_details["price"] = key1["total_price "]
         hotel_details["min daily rate"] = key1["min_daily_rate "]
         hotel_details["contact"] = key1["contacts"]
         hotel_details["rating"] = key1["awards"][0]
         hotel_details["room type"] = key1["room_type_info"]
         hotel_details["address"] = key1["address"]
       end
     end
     hotel_details
  end

def autocomplete(term)
	base_url = "http://api.sandbox.amadeus.com/v1.2/airports/autocomplete?apikey=P9Xuv7e4586ThMfR3nHlkojwJCR7ZHfe&term=${term}"
	data = open(base_url).read
	response = JSON.parse(data, headers: true, header_converters: :symbol)
end

# works in browswer not in terminal
# def flight_query(starting, departure_date, returning_date, budget)
# 	base_url = "http://api.sandbox.amadeus.com/v1.2/flights/inspiration-search?origin=#{starting}&departure_date=#{departure_date}--#{returning_date}&max_price=${budget}&apikey=P9Xuv7e4586ThMfR3nHlkojwJCR7ZHfe"
#     data = open(base_url).read
#     response = JSON.parse(data, headers: true, header_converters: :symbol)
# end
#
# def flights_parse_response(flight_query)
# 	flight_details = {}
# 			flight_query.each do |key, value|
# 	  	value.each do |key1, value1|
# 			hotel_details["destination"] = key1["destination"]
# 			hotel_details["departure_date"] = key1["departure_date"]
# 			hotel_details["return_date"] = key1["return_date"]
# 			hotel_details["price"] = key1["price"]
# 			hotel_details["airline"] = key1["airline"]
# 			end
#   	end
# 		puts flight_details
# end

end
