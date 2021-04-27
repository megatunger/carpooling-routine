class MatchingController < ApplicationController
  def pre_matching_calculate
    matching_params
    @user.pre_matching_process(@threshold)
    flash[:success] = 'Calculate successful!'
    redirect_to matching_pre_matching_path
  end

  def pre_matching
    matching_params
    Date::DAYNAMES.each_with_index { |x, i| @days << [x, i] }
  end

  private
  def matching_params
    @days = []
    @wday = 1
    @threshold = 2
    @user = User.first
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
    end
  end
end
