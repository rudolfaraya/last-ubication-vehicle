class Waypoint < ApplicationRecord
  belongs_to :vehicle
  has_many :jobs

  validates :latitude, numericality: { greater_than_or_equal_to:  -90, less_than_or_equal_to:  90 }
  validates :longitude, numericality: { greater_than_or_equal_to: -180, less_than_or_equal_to: 180 }

  def self.new_waypoint(vehicle, latitude, longitude, sent_at)
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

  def self.save_coordinate(coordinates)
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

  def self.update_last_waypoint(waypoint, message)
    Job.create(waypoint_id: waypoint.id,
               error: false,
               message: message)
    MapService.new.redis_update_waypoint(waypoint.vehicle.last_waypoint)
  end

  def self.check_waypoint(vehicle, latitude, longitude, sent_at)
    waypoint = vehicle.waypoints.find_by(sent_at: sent_at)
    if waypoint
      waypoint.update(latitude: latitude, longitude: longitude)
      waypoint
    else
      false
    end
  end

end
