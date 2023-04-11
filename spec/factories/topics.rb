FactoryBot.define do
  factory :topic do
    keyword { 'MyString' }
  end

  factory :topic_with_suggestions, class: Topic do
    sequence(:keyword) { |n| "keyword#{n}" }
    suggestions { build_list(:suggestion, 3) }
  end
end
