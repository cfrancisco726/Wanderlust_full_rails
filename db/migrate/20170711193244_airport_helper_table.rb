class AirportHelperTable < ActiveRecord::Migration[5.1]
  def change
    create_table :AirportHelperTable do |t|
      t.string :location
      t.string :airport_code
      t.decimal :longitude
      t.decimal :latitude
    end
  end
end
