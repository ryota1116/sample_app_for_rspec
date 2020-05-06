FactoryBot.define do
  factory :task do
    sequence(:title) { |n| "タイトル#{n}" }
    status { :todo }
    association :user, factory: :user
    # user
  end
end
