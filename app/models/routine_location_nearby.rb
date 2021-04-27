class RoutineLocationNearby < ApplicationRecord
  belongs_to :location_from, class_name: "Location", foreign_key: 'location_from_id'
  belongs_to :location_to, class_name: "Location", foreign_key: 'location_to_id'
end
