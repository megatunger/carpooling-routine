class User < ApplicationRecord
  has_many :locations
  has_many :train_models

  def create_lda_model(expecting_topics)
    init_params = ''
    mdl = ::Tomoto::LDA.new(tw: :one, min_cf: 3, rm_top: 5, k: expecting_topics, seed: 42)
    location_per_days = locations.group_by(&:group_by_criteria)
    location_per_days.each do |day|
      if day[1]
        mdl.add_doc(day[1].map{|location| "#{location.hashing_lda} "}.join)
      end
    end
    mdl.burn_in = 100
    mdl.train(0)
    100.times do |i|
      mdl.train(10)
    end
    filename = "tmp/model_user_#{id}_#{Time.now.getutc.to_i}.bin"
    mdl.save(filename)
    attached_model = train_models.create(
      params: (mdl.initial_params_info(init_params)).to_s
    )
    attached_model.model_file.attach(
      io: File.open(filename),
      filename: filename
    )
  end
end
