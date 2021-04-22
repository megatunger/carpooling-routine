class Location < ApplicationRecord
  belongs_to :user
  before_save :processing_lda_string, :add_time_range

  def group_by_criteria
    start_time.to_date.to_s(:db)
  end

  def processing_lda_string
    time_ranges = (0..23).map {|i| "#{i}h - #{(i+1)}h"}
    self.hashing_lda = "#{self&.address}_#{time_ranges[self.start_time.strftime('%H').to_i/3]}_#{self.start_time.strftime("%A").downcase}".parameterize.underscore
  end

  def add_time_range
    time_ranges = (0..23).map {|i| "#{i}h - #{(i+1)}h"}
    self.time_range = time_ranges[self.start_time.strftime('%H').to_i/3]
  end

  def get_longitude
    self.longitude*0.0000001
  end

  def get_latitude
    self.latitude*0.0000001
  end
end
