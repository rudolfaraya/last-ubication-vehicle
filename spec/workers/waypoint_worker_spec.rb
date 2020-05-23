require 'rails_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe WaypointWorker, type: :worker do
  describe 'Worker' do

    let(:waypoint) { FactoryBotRails.create(:waypoint) }

    it 'job in correct queue' do
      WaypointWorker.perform_async
      assert_equal :waypoint, WaypointWorker.queue
    end

    it 'should respond to #perform' do
      expect(WaypointWorker.new).to respond_to(:perform)
    end
  end
end
