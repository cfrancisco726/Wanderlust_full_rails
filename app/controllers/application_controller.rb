class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :logged_in?

  def current_user
    @user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    !!current_user
  end

  def req_body(origin, departure_date, arrival_date, passengers, budget)
    {"request": {
          "passengers": { "adultCount": passengers.to_i },
          "slice": [{
              "origin": origin,
              "destination": ['LAX','DEN'],
              "date": departure_date,
              "maxStops": 0,
            },
            {
              "origin": ['LAX','DEN'],
              "destination": origin,
              "date": arrival_date
            }
          ],
          "maxPrice": "USD#{budget}",
          "solutions": "5"
        }
      }
  end

  def api_call(body)
    RestClient.post 'https://www.googleapis.com/qpxExpress/v1/trips/search?key=AIzaSyAaLHEBBLCI4aHLNu2jHiiAQGDbCunBQX0',
    body.to_json, :content_type => :json
  end

  def parse_api_response(response)
    trips = []

    response["trips"]["tripOption"].each do |trip|
      h = {}
      h["saleTotal"]= trip["saleTotal"]
      h["carrier"] = trip["slice"][0]["segment"][0]["flight"]["carrier"]
      h["arrival_time_when_leaving_home"] = trip["slice"][0]["segment"][0]["leg"][0]["arrivalTime"]
      h["departure_time_when_leaving_home"] = trip["slice"][0]["segment"][0]["leg"][0]["departureTime"]
      h["arrival_time_when_coming_home"] = trip["slice"][1]["segment"][0]["leg"][0]["arrivalTime"]
      h["departure_time_when_coming_home"] = trip["slice"][1]["segment"][0]["leg"][0]["departureTime"]
      h["origin"] = trip["slice"][0]["segment"][0]["leg"][0]["origin"]
      h["destination"] = trip["slice"][0]["segment"][0]["leg"][0]["destination"]
      trips << h
    end
    trips
  end
end
