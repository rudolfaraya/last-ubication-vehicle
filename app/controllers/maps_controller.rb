class MapsController < ApplicationController
  def show
    @hash = MapService.new.redis_load
  end
end
