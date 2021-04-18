class CreateLocations < ActiveRecord::Migration[6.1]
  def change
    create_table :locations do |t|
      t.references :user
      t.string :location_name
      t.datetime :at_time
      t.timestamps
    end
  end
end
