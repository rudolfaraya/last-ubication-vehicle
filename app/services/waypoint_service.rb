class WaypointService
  def save_coordinate(coordinates)
    response = {}
    identifier = coordinates['vehicle_identifier'] if coordinates['vehicle_identifier']
    vehicle = Vehicle.find_or_create_by(identifier: identifier)
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