class WaypointWorker
  include Sidekiq::Worker
  sidekiq_options backtrace: 30
  sidekiq_options retry: 1
  sidekiq_options queue: :waypoint

  def perform(identifier, latitude, longitude, sent_at)
    vehicle = Vehicle.find_or_create_by(identifier: identifier)
    waypoint_updated = WaypointService.new.check_waypoint(vehicle, latitude, longitude, sent_at)
    if waypoint_updated
      update_last_waypoint(waypoint_updated, 'updated')
    else
      response = WaypointService.new.new_waypoint(vehicle, latitude, longitude, sent_at)
      if response.key?(:info)
        update_last_waypoint(response[:info], 'created')
      else
        raise 'Invalid Waypoint parameters'
      end
    end
  end

  def update_last_waypoint(waypoint, message)
    map = MapService.new
    Job.create(waypoint_id: waypoint.id,
               error: false,
               message: message)
    map.redis_update_waypoint(waypoint.vehicle.last_waypoint)
  end
end
