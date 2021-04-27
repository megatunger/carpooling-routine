class RoutineLocation < ApplicationRecord
  belongs_to :routine
  belongs_to :location

  has_many :routine_location_nearbies
end
