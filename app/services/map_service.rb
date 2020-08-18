class MapService
  def initialize
    begin
      puts 'Connecting to Redis...'
      @redis = Redis.new(url: "redis://#{ENV['REDIS_HOST']}:#{ENV['REDIS_PORT']}/2")
      @redis.inspect
    rescue Errno::ECONNREFUSED => e
      puts 'Error: Redis server unavailable. Shutting down...'
      exit 1
    end
  end

  def redis_initial_position
    Vehicle.all.each do |v|
      redis_update_waypoint(v.last_waypoint) if v.last_waypoint
    end
  end

  def redis_update_waypoint(waypoint)
    @redis.set("#{waypoint.vehicle.identifier}:lat", waypoint.latitude)
    @redis.set("#{waypoint.vehicle.identifier}:lng", waypoint.longitude)
  end

  def redis_load
    waypoints = []
    unless check_data
      Vehicle.all.each do |v|
        temp = {
          lat: @redis.get("#{v.identifier}:lat").to_f,
          lng: @redis.get("#{v.identifier}:lng").to_f,
          identifier: v.identifier
        }
        waypoints.push(temp)
      end
    end
    waypoints
  end

  def check_data
    v = Vehicle.last
    return false if v.nil?

    lat = @redis.get("#{v.identifier}:lat").to_f
    if lat == 0.0
      redis_initial_position
    else
      false
    end
  end

  def random_data(vehicle_number, waypoint_number)
    url = 'http://localhost:3000/api/gps'
    vehicle_number.times.each do
      vehicle = FactoryBot.create(:vehicle)
      waypoint_number.times.each do
        body = {
          "latitude" => Faker::Address.latitude,
          "longitude"=> Faker::Address.longitude,
          "sent_at" => Faker::Time.between(from: DateTime.now - 1.year, to: DateTime.now),
          "vehicle_identifier" => vehicle.identifier
        }
        HTTParty.post(url, body: body)
      end
    end
  end
end