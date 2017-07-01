class CreateTrips < ActiveRecord::Migration[5.1]
  def change
    create_table :trips do |t|
      t.integer :budget
      t.string :origin
      t.date :date
      t.integer :passengers
      t.boolean :booked?
      t.references :user

      t.timestamps
    end
  end
end
