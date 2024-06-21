FactoryBot.define do
  factory :task do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    state { 0 }
    deadline { Faker::Time.forward(days: 5, period: :morning) }
    association :user

    trait :in_progress do
      state { 1 }
    end

    trait :done do
      state { 2 }
    end
  end
end