require 'color-generator'

class MatchingController < ApplicationController
  def pre_matching_calculate
    matching_params
    User.all.each do |user|
      user.pre_matching_process(@threshold)
    end
    flash[:success] = 'Calculate successful!'
    redirect_to matching_pre_matching_path
  end

  def pre_matching
    matching_params
    Date::DAYNAMES.each_with_index { |x, i| @days << [x, i] }
    @generator = ColorGenerator.new(saturation: 1.0, lightness: 0.3)
  end

  def live_matching
    matching_params
    Date::DAYNAMES.each_with_index { |x, i| @days << [x, i] }
    @time_ranges = (0..23).map {|i| "#{i}h - #{(i+1)}h"}
    if params[:start_point]
      @start_point = Location.new(latitude: params[:start_point][:latitude], longitude: params[:start_point][:longitude])
      @end_point = Location.new(latitude: params[:end_point][:latitude], longitude: params[:end_point][:longitude])
      @choices = []
      Routine.where(week_day: @wday).each do |routine|
        @choices << routine.sorted_routine_locations.select do |routine_location|
          routine_location.location.time_range == @time_range && routine_location.location.distance_from(@start_point) <= 2
        end.map(&:location)
      end
    end


  end

  private
  def matching_params
    @days = []
    @wday = 1
    @threshold = 5
    @user = User.first
    @time_range = '8h - 9h'
    if params[:matching_form]
      if params[:matching_form][:threshold_distance]
        @threshold = params[:matching_form][:threshold_distance].to_i
      end
      if params[:matching_form][:wday]
        @wday = params[:matching_form][:wday].to_i
      end
      if params[:matching_form][:user_id]
        @user = User.find(params[:matching_form][:user_id].to_i)
      end
      if params[:matching_form][:time_range]
        @time_range = params[:matching_form][:time_range]
      end
    end
  end
end
