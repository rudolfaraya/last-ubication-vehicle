class Vehicle < ApplicationRecord
  validates_presence_of :identifier
  validates :identifier, uniqueness: true

  has_many :waypoints

  def last_waypoint
    waypoints.order(:sent_at).last
  end
end
