class CreateHotels < ActiveRecord::Migration[5.1]
  def change
    create_table :hotels do |t|
      t.string :property_name
      t.string :location
      t.string :room_type_code
      t.string :total_price
      t.string :min_daily_rate
      t.string :contacts
      t.string :awards
      t.string :room_type_code
      t.string :address

      t.timestamps
    end
  end
end
