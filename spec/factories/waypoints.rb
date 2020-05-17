FactoryBot.define do
  factory :waypoint do
    vehicle { nil }
    sent_at { "2020-05-17 18:02:37" }
    latitude { 1.5 }
    longitude { 1.5 }
  end
end
