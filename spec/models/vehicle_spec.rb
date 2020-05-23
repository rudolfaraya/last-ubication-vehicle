require 'rails_helper'

RSpec.describe Vehicle, type: :model do
  describe 'Validations' do
    it { should validate_presence_of(:identifier) }
    it { should validate_uniqueness_of(:identifier) }
  end
end
