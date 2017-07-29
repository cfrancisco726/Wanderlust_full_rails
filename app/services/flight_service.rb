class FlightService
  QPX_KEY = "AIzaSyDi9KP9NPSx8sus_vV2AM_JHF407fAPjfU"

  def self.get_flights(query)
    RestClient.post("https://www.googleapis.com/qpxExpress/v1/trips/search?key=#{QPX_KEY}", 
      format_query(query), :content_type => :json)
  end

  def self.format_query(query)
    {"request": {
          "passengers": { "adultCount": query[:passengers].to_i },
          "slice": [{
              "origin": query[:origin],
              "destination": query[:destination_airport_code],
              "date": query[:departure_date],
              "maxStops": 0,
            },
            {
              "origin": query[:destination_airport_code],
              "destination": query[:origin],
              "date": query[:arrival_date]
            }
          ],
          "maxPrice": "USD#{query[:budget]}",
          "solutions": "1"
        }
      }.to_json
  end

end
