class WaypointWorker
  include Sidekiq::Worker
  sidekiq_options backtrace: 30
  sidekiq_options retry: 1
  sidekiq_options queue: :waypoint

  def perform(identifier, latitude, longitude, sent_at)
    vehicle = Vehicle.find_or_create_by(identifier: identifier)
    raise 'Latitude not provided' if latitude.nil?
    raise 'Longitude not provided' if longitude.nil?
    raise 'Sent_at not provided' if sent_at.nil?

    waypoint_updated = Waypoint.check_waypoint(vehicle, latitude, longitude, sent_at)
    if waypoint_updated
      Waypoint.update_last_waypoint(waypoint_updated, 'updated')
    else
      response = Waypoint.new_waypoint(vehicle, latitude, longitude, sent_at)
      if response.key?(:info)
        Waypoint.update_last_waypoint(response[:info], 'created')
      else
        raise 'Invalid Waypoint parameters'
      end
    end
  end
end
