class Vehicle < ApplicationRecord
  validates_presence_of :identifier
  validates :identifier, uniqueness: true
end
