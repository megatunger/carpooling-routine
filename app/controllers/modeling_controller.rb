require 'tomoto'
require 'tomoto/lda'

class ModelingController < ApplicationController
  def pre_processing_lda
    @time_ranges = (0..7).map {|i| "#{i*3}h - #{(i+1)*3}h"}
    @start_time = Date.new(2020, 01, 01)
    @end_time = Date.new(2020, 02, 01)
    if search_params
      @start_time = Date.parse(search_params[:start_time])
      @end_time = Date.parse(search_params[:end_time])
    end
    @entries = Location.includes(:user)
                 .where('start_time >= ? and end_time < ?', @start_time, @end_time)
                 .sort_by(&:start_time)
                 .group_by(&:group_by_criteria)
  end

  def training_lda
    mdl = ::Tomoto::LDA.new(tw: :one, min_cf: 3, rm_top: 5, k: 20, seed: 42)
    @docs = []
    User.all.each do |user|
      location_per_days = user.locations.group_by(&:group_by_criteria)
      location_per_days.each do |day|
        if day[1]
          @docs << day[1].map{|location| "#{location.hashing_lda} "}.join
        end
      end
    end
    @docs.each do |doc|
      mdl.add_doc(doc)
    end
    puts mdl
    mdl.burn_in = 100
    mdl.train(0)
    @infor = "Num docs: #{mdl.num_docs}, Vocab size: #{mdl.used_vocabs.length}, Num words: #{mdl.num_words}"
    @infor_removed_words = "Removed top words: #{mdl.removed_top_words}"
    puts "Training..."
    100.times do |i|
      mdl.train(10)
      puts "Iteration: #{i * 10}\tLog-likelihood: #{mdl.ll_per_word}"
    end

    puts mdl.summary
    #
    #
    #
    # puts "Saving..."
    # mdl.save(save_path)
    #
    # mdl.k.times do |k|
    #   puts "Topic ##{k}"
    #   mdl.topic_words(k).each do |word, prob|
    #     puts "\t\t#{word}\t#{prob}"
    #   end
    # end
  end

  def index

  end

  def search_params
    if params[:search].present?
      params.require(:search).permit(:start_time, :end_time)
    end
  end
end
