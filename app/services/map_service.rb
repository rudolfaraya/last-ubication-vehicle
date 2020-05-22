class MapService
  def initialize
    begin
      puts 'Connecting to Redis...'
      @redis = Redis.new
      @redis.inspect
    rescue Errno::ECONNREFUSED => e
      puts 'Error: Redis server unavailable. Shutting down...'
      exit 1
    end
  end

  def redis_update_waypoint(waypoint)
    @redis.set("#{waypoint.vehicle.identifier}:lat", waypoint.latitude)
    @redis.set("#{waypoint.vehicle.identifier}:lng", waypoint.longitude)
  end

  def redis_load
    waypoints = []
    Vehicle.all.each do |v|
      temp = {
        lat: @redis.get("#{v.identifier}:lat").to_f,
        lng: @redis.get("#{v.identifier}:lng").to_f
      }
      waypoints.push(temp)
    end
    waypoints
  end
end