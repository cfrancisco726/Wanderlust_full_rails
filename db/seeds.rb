# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

flights = {
    "DEN" => {"location" => "Denver", "lat" => 39.8561, "lng" => -104.6737, "image_url"=>"denver.jpg"},
    "LAX" => {"location"=>"Los Angeles","lat" => 33.9416, "lng" => -118.4085, "image_url"=>"LAX.jpg"},
    "MIA" => {"location"=>"Miami","lat" => 25.7959, "lng" => -80.2870, "image_url"=>"MIAMI.jpg"},
    "FCO" => {"location"=>"Italy","lat" => 41.7998868, "lng" => 12.246238400000038, "image_url"=>"italy.jpg"},
    "SYD" => {"location"=>"Sydney","lat" => -33.8688, "lng" => 151.2093, "image_url"=>"Sydney.jpg"},
    "LHR" => {"location"=>"London","lat" => 51.5074, "lng" => -0.1278, "image_url"=>"london.jpg"},
    "CDG" => {"location"=>"Paris","lat" => 48.8566, "lng" => 2.3522, "image_url"=>"Paris.jpg"},
    "PRG" => {"location"=>"Prague","lat" => 50.0755, "lng" => 14.4378, "image_url"=>"Prague.jpg"},
    "DXB"  => {"location"=>"Dubai","lat" => 25.2048, "lng" => 55.2708, "image_url"=>"Dubai.jpg"},
    "JTR" => {"location"=>"Santorini","lat" => 36.3932, "lng" => 25.4615, "image_url"=>"Santorini.jpg"},
    "HNL" => {"location"=>"Honolulu","lat" => 21.3069, "lng" => -157.8583, "image_url"=>"Honolulu.jpg"},
    "DPS" => {"location"=>"Bali","lat" => -8.409518, "lng" => 115.188919, "image_url"=>"Bali.jpg"}, 
    "YVR"=> {"location"=>"Vancouver","lat" => 49.2827, "lng" => -123.1207, "image_url"=>"Vancouver.jpg"},
    "HKT" =>{"location"=>"Phuket","lat" => 7.9519, "lng" => 98.3381, "image_url"=>"Phuket.jpg"},
    "EAS"=>{"location"=>"San Sebastian","lat" => 43.3183, "lng" => -1.9812, "image_url"=>"San-Sebastian.jpg"},
    "PPT"=>{"location"=>"tahiti","lat" => -17.6509, "lng" => -149.4260, "image_url"=>"tahiti.jpg"},
    "FAT"=>{"location"=>"Yosemite","lat" => 37.8651, "lng" => -119.5383, "image_url"=>"Yosemite.jpg"},
    "SJO"=>{"location"=>"Costa Rica","lat" => 9.7489, "lng" => -83.7534, "image_url"=>"CostaRica.jpg"},
    "SLC" =>{"location"=>"Salt Lake City","lat" => 40.7608, "lng" => -111.8910, "image_url"=>"saltlakecity.jpg"},
    "JAC" => {"location"=>"Jackson Hole","lat" => 43.4799, "lng" => -110.7624, "image_url"=>"jacksonhole.jpg"}
  }

  flights.each do |flight, stats|
AirportHelperTable.create(airport_code: flight, location: stats["location"], longitude: stats["lng"], latitude: stats["lat"], image_url: stats["image_url"])
end