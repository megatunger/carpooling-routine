class Location < ApplicationRecord
  belongs_to :user
  before_save :processing_lda_string

  def group_by_criteria
    start_time.to_date.to_s(:db)
  end

  def processing_lda_string
    time_ranges = (0..7).map {|i| "#{i*3}h - #{(i+1)*3}h"}
    self.hashing_lda = "#{self&.address}_#{time_ranges[self.start_time.strftime('%H').to_i % 3]}".parameterize.underscore
  end
end
