class RoutineLocation < ApplicationRecord
  # belongs_to :routine_location
  belongs_to :location

  has_many :routine_location_nearbies, foreign_key: 'routine_location_id'
end
