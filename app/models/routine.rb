class Routine < ApplicationRecord
  scope :all_except_self_routines, ->(routine) { where.not(id: routine.id, user_id: routine.user_id) }
  has_many :routine_locations
  has_many :locations, through: :routine_locations

  def sorted_routine_locations
    routine_locations.includes(:location).order('locations.time_range ASC').uniq { |p| p.location.time_range && p.location.address }
  end

  def google_maps_path(color='ff0000ff')
    points = sorted_routine_locations.map(&:location).map{|location_object| "#{location_object&.latitude&.round(2)},#{location_object&.longitude&.round(4)}"}.join("|")
    "path=color:0x#{color}|weight:5|#{points}"
  end

  def google_maps_image
    "http://maps.googleapis.com/maps/api/staticmap?zoom=13&size=1000x1000&#{google_maps_path}&key=#{ENV['GOOGLE_MAP_API_KEY']}"
  end

  def routine_nearby(threshold)
    results = []
    Routine.all_except_self_routines(self).where(week_day: self.week_day).each do |destination_routine|
      flag = true
      destination_routine_locations = destination_routine.sorted_routine_locations
      self.sorted_routine_locations.each_with_index do |original_routine_location, index|
        destination_location = destination_routine_locations.filter{|r| r.location.time_range == original_routine_location.location.time_range}&.first&.location
        if original_routine_location.location.distance_from(destination_location) >= threshold
          flag = false
        end
      end
      if flag
        results << destination_routine
      end
    end
    results
  end

  def find_pick_up_point(routine_of_member)
    minimum_distance = Float::MAX
    pickup_point = nil
    sorted_routine_locations.each do |routine_location|
      routine_of_member.sorted_routine_locations.each do |member_routine_location|
        distance = member_routine_location.location.distance_from(routine_location.location)
        if distance < minimum_distance
          pickup_point = routine_location
        end
      end
    end
    pickup_point
  end
end
