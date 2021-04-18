require 'tomoto'
require 'tomoto/lda'

class ModelingController < ApplicationController
  def index
    input_file = File.open('db/enwiki-stemmed-1000.txt')
    puts input_file
    model = Tomoto::LDA.new(k: 2)
    model.add_doc("text from document one")
    model.add_doc("text from document two")
    model.add_doc("text from document three")
    model.train(100)
    # mdl = ::Tomoto::LDA.new(tw: :one, min_cf: 3, rm_top: 5, k: 20, seed: 42)
    # File.foreach(input_file) do |line|
    #   ch = line.strip.split(/[[:space:]]+/)
    #   mdl.add_doc(ch)
    # end
    # puts mdl
    # mdl.burn_in = 100
    # mdl.train(0)
    # puts "Num docs: #{mdl.num_docs}, Vocab size: #{mdl.used_vocabs.length}, Num words: #{mdl.num_words}"
    # puts "Removed top words: #{mdl.removed_top_words}"
    # puts "Training..."
    # 100.times do |i|
    #   mdl.train(10)
    #   puts "Iteration: #{i * 10}\tLog-likelihood: #{mdl.ll_per_word}"
    # end
    #
    # puts mdl.summary
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
end
