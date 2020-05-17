FactoryBot.define do
  factory :waypoint do
    vehicle
    sent_at { Faker::Time.between(from: DateTime.now - 1.year, to: DateTime.now) }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
  end
end
