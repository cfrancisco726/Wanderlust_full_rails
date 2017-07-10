class CreateResponseFlightData < ActiveRecord::Migration[5.1]
  def change
    create_table :response_flight_data do |t|
      t.string :saleTotal
      t.string :carrier
      t.string :arrival_time_when_leaving_home
      t.string :departure_time_when_leaving_home
      t.string :arrival_time_when_coming_home
      t.string :departure_time_when_coming_home
      t.string :origin
      t.string :destination

      t.timestamps
    end
  end
end
