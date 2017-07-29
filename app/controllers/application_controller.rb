class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :lat_long, :current_user, :logged_in?, :api_call, :parse_api_response, :convert_airportcode_to_destination, :flights_date, :hotel_query, :hotel_query


  def current_user
    @user = User.find_by(id: session[:user_id])
  end

  def logged_in?
    !!current_user
  end



  def flights_date(flight_time)
    DateTime.parse(flight_time).strftime("%a %b %e at  %H:%M %p")
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
    elsif airport_code == "CLO"
      "Cali"
    elsif airport_code == "CPT"
      "Capetown"
    elsif airport_code == "LOS"
      "Lagos"
    elsif airport_code == "GIG"
      "Rio De Janeiro"
    elsif airport_code == "MNL"
      "Manila"
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

end
