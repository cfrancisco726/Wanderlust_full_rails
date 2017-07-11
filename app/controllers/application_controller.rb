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

  def lat_long(convert_airportcode_to_destination(airport_code))
      if "Denver"
        lat = 39.8561
        lng = -104.6737
    elsif "Los Angeles"
        lat = 33.9416
        lng = -118.4085
    elsif "Miami"
        lat = 25.7959
        lng = -80.2870
    elsif "Italy"
        lat = 41.7998868
        lng = 12.246238400000038
    elsif "Sydney"
        lat = -33.8688
        lng = 151.2093
    elsif "London"
        lat = 51.5074
        lng = -0.1278
    elsif "Paris"
        lat = 48.8566
        lng = 2.3522
    elsif "Prague"
        lat = 50.0755
        lng = 14.4378
    elsif "Dubai"  
        lat = 25.2048
        lng = 55.2708
    elsif "Santorini"
        lat = 36.3932
        lng = 25.4615
    elsif "Honolulu"
        lat = 21.3069
        lng = -157.8583
    elsif "Bali" 
        lat = -8.409518
        lng = 115.188919 
    elsif "Vancouver"
        lat = 49.2827
        lng = -123.1207
    elsif  "Phuket" 
        lat = 7.9519
        lng = 98.3381
    elsif "San Sebastian"
        lat = 43.3183
        lng = -1.9812
    elsif "Tahiti"
        lat = -17.6509
        lng = -149.4260
    elsif "Yosemite"
        lat = 37.8651
        lng = -119.5383
    elsif "Costa Rica"
        lat = 9.7489
        lng = -83.7534
    elsif "Salt Lake City"
        lat = 40.7608
        lng = -111.8910
    elsif "Jackson Hole" 
        lat = 43.4799
        lng = -110.7624               
    end
  end


end
