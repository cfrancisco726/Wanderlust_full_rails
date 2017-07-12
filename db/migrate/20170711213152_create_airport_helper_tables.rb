class CreateAirportHelperTables < ActiveRecord::Migration[5.1]
  def change
    create_table :airport_helper_tables do |t|
      t.string :location
      t.string :airport_code
      t.decimal :longitude
      t.decimal :latitude
      t.string :image_url
      t.timestamps
    end
  end
end
