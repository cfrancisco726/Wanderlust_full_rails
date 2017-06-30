class CreateHotels < ActiveRecord::Migration[5.1]
  def change
    create_table :hotels do |t|
      t.string :name
      t.integer :price
      t.boolean :booked?
      t.references :trip

      t.timestamps
    end
  end
end
