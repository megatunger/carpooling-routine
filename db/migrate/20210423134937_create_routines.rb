class CreateRoutines < ActiveRecord::Migration[6.1]
  def change
    create_table :routines do |t|
      t.references :user
      t.integer :week_day
      t.timestamps
    end
    create_table :routine_locations do |t|
      t.references :routine
      t.references :location
      t.timestamps
    end
  end
end
