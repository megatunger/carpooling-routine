class CreateTrainModels < ActiveRecord::Migration[6.1]
  def change
    create_table :train_models do |t|
      t.string :params
      t.references :user
      t.integer :week_day
      t.timestamps
    end
  end
end
