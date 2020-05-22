FactoryBot.define do
  factory :job do
    waypoint
    error { false }
    message { 'created' }
  end
end
