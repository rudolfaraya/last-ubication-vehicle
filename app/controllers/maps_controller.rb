class MapsController < ApplicationController
  def show
    @hash = MapService.new.waypoint_hash
  end
end
