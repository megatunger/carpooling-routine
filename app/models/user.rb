class User < ApplicationRecord
  has_many :locations
  has_many :train_models
  has_many :routines

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

  def save_model_to_routine
    routines.destroy_all
    train_models.each do |model|
      model.model_file.open do |file|
        mdl = ::Tomoto::LDA.load(file.path)
        mdl.topics_info([], topic_word_top_n: 10).take(5).each do |topic|
          routine = routines.create(week_day: model.week_day)
          topic.each do |pos|
            location_object = Location.where(hashing_lda: pos[0], user_id: self.id).where("extract(dow from start_time) = ?", model.week_day)&.first
            if location_object
              routine.locations << location_object
            end
          end
        end
      end
    end
  end

  def pre_matching_process(threshold)
    self.routines.each do |routine|
      routine.locations.each do |location|
        routine_locations = RoutineLocation.where(
          routine_id: Routine.where(
            user_id: User.where.not(id: self.id).pluck(:id),
            week_day: routine.week_day
          ).pluck(:id),
          location_id: Location.where(time_range: location.time_range).pluck(:id)
        )
        routine_locations.each do |routine_location|
          location_to = routine_location.location
          if location.distance_from(location_to) <= threshold
            RoutineLocationNearby.create(
              routine_location_id: routine_location.id,
              location_from_id: location.id,
              location_to_id: location_to.id,
              user_from_id: location.user_id,
              user_to_id: location_to.user_id,
              distance: location.distance_from(location_to),
              week_day: routine.week_day,
              time_range: location.time_range
            )
          end
        end
      end
    end
  end
end
