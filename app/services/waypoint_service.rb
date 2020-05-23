class WaypointService
  def save_coordinate(coordinates)
    response = {}
    if coordinates['vehicle_identifier']
      identifier = coordinates['vehicle_identifier']
      latitude = coordinates['latitude']
      longitude = coordinates['longitude']
      sent_at = coordinates['sent_at']
      WaypointWorker.perform_async(identifier, latitude, longitude, sent_at)
    else
      response[:errors] = 'Vehicle identifier not supplied'
      return response
    end
    coordinates
  end

  def check_waypoint(vehicle, latitude, longitude, sent_at)
    waypoint = vehicle.waypoints.find_by(sent_at: sent_at)
    if waypoint
      waypoint.update(latitude: latitude, longitude: longitude)
      waypoint
    else
      false
    end
  end

  def new_waypoint(vehicle, latitude, longitude, sent_at)
    response = {}
    new_waypoint = Waypoint.new(latitude: latitude,
                                longitude: longitude,
                                vehicle_id: vehicle.id,
                                sent_at: sent_at)
    if new_waypoint.save
      response[:info] = new_waypoint
    else
      response[:errors] = new_waypoint.errors
    end
    response
  end
end