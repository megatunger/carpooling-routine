class Routine < ApplicationRecord
  has_many :routine_locations
  has_many :locations, through: :routine_locations
end
