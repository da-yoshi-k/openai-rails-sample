FactoryBot.define do
  factory :suggestion do
    sequence(:content) { |n| "suggestion#{n}" }
    association :topic
  end
end
