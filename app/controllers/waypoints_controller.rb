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

  def coordinates_params
    params.permit(:latitude, :longitude, :sent_at, :vehicle_identifier)
  end
end
