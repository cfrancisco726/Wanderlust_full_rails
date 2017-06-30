class CreateFlights < ActiveRecord::Migration[5.1]
  def change
    create_table :flights do |t|
      t.string :departing_airline
      t.string :arriving_airline
      t.integer :flight_price
      t.boolean :booked?
      t.text :flight_number
      t.references :trip


      t.timestamps
    end
  end
end
