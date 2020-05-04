FactoryBot.define do
  factory :task do
    sequence(:title) { |n| "タイトル#{n}" }
    status { :todo }
  end
end
