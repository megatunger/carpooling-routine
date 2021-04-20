class TrainModel < ApplicationRecord
  has_one_attached :model_file, dependent: :purge_now
end
