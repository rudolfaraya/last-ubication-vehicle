require 'rails_helper'

RSpec.describe Job, type: :model do
  describe 'Associations' do
    it { should belong_to(:waypoint) }
  end
end
