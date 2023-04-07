FactoryBot.define do
  factory :suggestion do
    content { 'MyString' }
    association :topic
  end
end
