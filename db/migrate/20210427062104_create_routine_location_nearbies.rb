class CreateRoutineLocationNearbies < ActiveRecord::Migration[6.1]
  def change
    create_table :routine_location_nearbies do |t|
      t.references :routine_location
      t.belongs_to :location_from
      t.belongs_to :user_from
      t.belongs_to :location_to
      t.belongs_to :user_to
      t.integer :week_day
      t.float :distance
      t.string :time_range, index: true
      t.timestamps
    end
  end
end
