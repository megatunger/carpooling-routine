class LocationsController < ApplicationController
  def index
    @locations = Location.page(params[:page])
  end
end