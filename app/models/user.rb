class User < ApplicationRecord
  has_many :locations
  has_many :train_models

  def create_lda_model(expecting_topics)
    train_models.destroy_all
    init_params = ''
    mdl_monday = ::Tomoto::LDA.new(tw: :one, min_cf: 3, rm_top: 5, k: expecting_topics, seed: 42)
    mdl_tuesday = ::Tomoto::LDA.new(tw: :one, min_cf: 3, rm_top: 5, k: expecting_topics, seed: 42)
    mdl_wednesday = ::Tomoto::LDA.new(tw: :one, min_cf: 3, rm_top: 5, k: expecting_topics, seed: 42)
    mdl_thursday = ::Tomoto::LDA.new(tw: :one, min_cf: 3, rm_top: 5, k: expecting_topics, seed: 42)
    mdl_friday = ::Tomoto::LDA.new(tw: :one, min_cf: 3, rm_top: 5, k: expecting_topics, seed: 42)
    mdl_saturday = ::Tomoto::LDA.new(tw: :one, min_cf: 3, rm_top: 5, k: expecting_topics, seed: 42)
    mdl_sunday = ::Tomoto::LDA.new(tw: :one, min_cf: 3, rm_top: 5, k: expecting_topics, seed: 42)
    models = [mdl_sunday, mdl_monday, mdl_tuesday, mdl_wednesday, mdl_thursday, mdl_friday, mdl_saturday]
    location_per_days = locations.group_by(&:group_by_criteria)
    location_per_days.each do |day|
      wday = Date.parse(day[0]).wday
      if day[1]
        string_trip = day[1].map{|location| "#{location.hashing_lda} "}.join
        case wday
        when 0
          mdl_sunday.add_doc(string_trip)
        when 1
          mdl_monday.add_doc(string_trip)
        when 2
          mdl_tuesday.add_doc(string_trip)
        when 3
          mdl_wednesday.add_doc(string_trip)
        when 4
          mdl_thursday.add_doc(string_trip)
        when 5
          mdl_friday.add_doc(string_trip)
        when 6
          mdl_saturday.add_doc(string_trip)
        end
      end
    end
    models.each_with_index do |mdl, index|
      mdl.burn_in = 100
      mdl.train(0)
      100.times do |i|
        mdl.train(10)
      end
      filename = "tmp/model_user_#{id}_wday_#{index}_#{Time.now.getutc.to_i}.bin"
      mdl.save(filename)
      attached_model = train_models.create(
        params: (mdl.initial_params_info(init_params)).to_s,
        week_day: index
      )
      attached_model.model_file.attach(
        io: File.open(filename),
        filename: filename
      )
    end
  end
end
