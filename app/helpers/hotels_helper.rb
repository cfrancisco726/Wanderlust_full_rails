def reqBody(budget, checkIn, checkOut, numRooms, numTravelers,  longitude, latitude, maxRate) {
return({"request": {
    "stay": {
      "checkIn": checkIn,
      "checkOut": checkOut
    },
    "occupancies": [
      {
        "rooms": numRooms,
        "adults": numTravelers,
        "children": 0,
      }
    ],
    "geolocation": {
      "longitude": -2.021484375,
      "latitude": 45.37680856570233,
      "radius": 20,
      "unit": "mi",
    }
      "filter": {
        "maxRate": budget
    }
}

def api_call_hotel(body)
  RestClient.post 'https://api.test.hotelbeds.com/hotel-api/1.0/hotels/search?key=tt373n7gnkmqfweypk45tzrg',
  body.to_json, :content_type => :json
end
