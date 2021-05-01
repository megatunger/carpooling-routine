require 'tomoto'
require 'tomoto/lda'

class ModelingController < ApplicationController

  def pre_processing_lda
    @start_time = Date.new(2020, 01, 01)
    @end_time = Date.new(2020, 02, 01)
    @user = User.first
    if search_params
      @start_time = Date.parse(search_params[:start_time])
      @end_time = Date.parse(search_params[:end_time])
      @user = User.find(search_params[:user_id])
    end
    @entries = Location.includes(:user).where(user_id: @user&.id)
                 .where('start_time >= ? and end_time < ?', @start_time, @end_time)
                 .sort_by(&:start_time)
                 .group_by(&:group_by_criteria)
  end

  def get_training_lda
    @expecting_topics = 20
    @users = User.all
  end

  def training_lda
    @expecting_topics = 20
    if params['train_form']
      @expecting_topics = params['train_form']['topics'].to_i
    end
    User.all.each do |user|
      user.create_lda_model(@expecting_topics)
    end
    flash[:success] = "Save model successfully!"
    redirect_to modeling_training_lda_path
  end

  def routes_trip_lda
    @days = []
    Date::DAYNAMES.each_with_index { |x, i| @days << [x, i] }
    @wday = 1
    @place = Location.first
    if params['analysis_form']
      @user = User.find(params['analysis_form']['user_id'].to_i)
      @wday = params['analysis_form']['wday'].to_i
      @models = []
      @user.train_models.where(week_day: @wday)&.last.model_file.open do |file|
        @mdl = ::Tomoto::LDA.load(file.path)
      end
    end
  end

  def save_routines_to_db
    User.all.each do |user|
      user.save_model_to_routine
    end
    flash[:success] = "Save routines to database successfully!"
    redirect_to modeling_training_lda_path
  end


  def search_params
    if params[:search].present?
      params.require(:search).permit(:start_time, :end_time, :user_id)
    end
  end

  def after_save_routines
    @days = ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday']
    @users = User.all
  end
end
