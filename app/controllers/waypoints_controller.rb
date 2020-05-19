class WaypointsController < ApplicationController
  def gps
    response = WaypointService.new.save_coordinate(coordinates_params)
    if response[:errors]
      render json: response, status: :bad_request
    else
      render json: response, status: :created
    end
  end

  private

  def set_vehicle
    @vehicle = Vehicle.find_or_create_by(name: params[:vehicle_identifier])
  end

  def coordinates_params
    params.permit(:latitude, :longitude, :sent_at, :vehicle_identifier)
  end
end
