class RoutineLocationNearby < ApplicationRecord
  belongs_to :location_from, class_name: "Location", foreign_key: 'location_from_id'
  belongs_to :user_from, class_name: "User", foreign_key: 'user_from_id'
  belongs_to :location_to, class_name: "Location", foreign_key: 'location_to_id'
  belongs_to :user_to, class_name: "User", foreign_key: 'user_to_id'
end
