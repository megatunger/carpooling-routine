class CreateLocations < ActiveRecord::Migration[6.1]
  def change
    create_table :locations do |t|
      t.references :user
      t.bigint :latitude
      t.bigint :longitude
      t.string :place_id
      t.string :location_name
      t.string :address
      t.string :semantic_type
      t.float :confidence
      t.datetime :start_time
      t.datetime :end_time
      t.string :hashing_lda
      t.string :time_range
      t.timestamps
    end
  end
end
