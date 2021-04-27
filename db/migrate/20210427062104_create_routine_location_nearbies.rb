class CreateRoutineLocationNearbies < ActiveRecord::Migration[6.1]
  def change
    create_table :routine_location_nearbies do |t|
      t.references :routine
      t.belongs_to :location_from
      t.belongs_to :location_to
      t.references :user
      t.integer :week_day
      t.float :distance
      t.timestamps
    end
  end
end
