class WaypointService
  def save_coordinate(coordinates)
    response = {}
    if coordinates['vehicle_identifier']
      identifier = coordinates['vehicle_identifier']
    else
      response[:errors] = 'Vehicle identifier not supplied'
      return response
    end

    vehicle = Vehicle.find_or_create_by(identifier: identifier)
    waypoint_updated = check_waypoint(vehicle, coordinates)
    if waypoint_updated
      response[:info] = waypoint_updated
    else
      response = new_waypoint(coordinates, vehicle, response)
    end
    response
  end

  def check_waypoint(vehicle, new_waypoint)
    waypoint = vehicle.waypoints.find_by(sent_at: new_waypoint['sent_at'])
    if waypoint
      waypoint.update(latitude: new_waypoint['latitude'], longitude: new_waypoint['longitude'])
      waypoint
    else
      false
    end
  end

  def new_waypoint(coordinates, vehicle, response)
    new_waypoint = Waypoint.new(latitude: coordinates['latitude'],
                                longitude: coordinates['longitude'],
                                vehicle_id: vehicle.id,
                                sent_at: coordinates['sent_at'])
    if new_waypoint.save
      response[:info] = new_waypoint
    else
      response[:errors] = new_waypoint.errors
    end
    response
  end
end