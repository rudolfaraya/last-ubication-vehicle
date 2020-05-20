class MapService
  def waypoint_hash
    waypoints = []
    Vehicle.all.each do |vehicle|
      last_waypoint = vehicle.last_waypoint
      temp = {
        lat: last_waypoint.latitude,
        lng: last_waypoint.longitude
      }
      waypoints.push(temp)
    end
    waypoints
  end
end