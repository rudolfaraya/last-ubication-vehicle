require 'rails_helper'

RSpec.describe Waypoint, type: :model do
  describe 'Associations' do
    it { should belong_to(:vehicle) }
    it { should validate_numericality_of(:latitude) }
    it { should validate_numericality_of(:longitude) }
  end
end
