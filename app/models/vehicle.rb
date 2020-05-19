class Vehicle < ApplicationRecord
  validates_presence_of :identifier
  validates :identifier, uniqueness: true

  has_many :waypoints
end
