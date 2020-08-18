class MapsController < ApplicationController
  before_action :check_waypoints, only: :show
  def show
  end

  private

  def check_waypoints
    @hash = MapService.new.redis_load
  end

end
