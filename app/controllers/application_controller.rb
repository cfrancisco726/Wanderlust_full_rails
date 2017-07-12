class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user, :logged_in?, :api_call, :parse_api_response, :convert_airportcode_to_destination, :flights_date


  def current_user
    @user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    !!current_user
  end

  def req_body_den(origin, departure_date, arrival_date, passengers, budget)
    {"request": {
          "passengers": { "adultCount": passengers.to_i },
          "slice": [{
              "origin": origin,
              "destination": ['DEN'],
              "date": departure_date,
              "maxStops": 0,
            },
            {
              "origin": ['DEN'],
              "destination": origin,
              "date": arrival_date
            }
          ],
          "maxPrice": "USD#{budget}",
          "solutions": "10"
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
          "solutions": "10"
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
    RestClient.post 'https://www.googleapis.com/qpxExpress/v1/trips/search?key=AIzaSyDQlVvdzPVGCZ7UZdovGEeyREAXvKdteV0',
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
    end
  end

  def api_call_hotel(check_in, max_rate)
    base_url = "http://api.sandbox.amadeus.com/v1.2/hotels/search-circle?latitude=latitude=43.6&longitude=7.2&radius=50&check_in=#{check_in}&check_out=#{'2017-09-03'}&chain=RT&cy=USD&number_of_results=20&max_rate=#{max_rate}&apikey=P9Xuv7e4586ThMfR3nHlkojwJCR7ZHfe"
    data = open(base_url).read
    response = JSON.parse(data, headers: true, header_converters: :symbol)
  end

end
