class ApplicationController < ActionController::Base
  def index
    @users = User.all
    render 'application/index'
  end
end
