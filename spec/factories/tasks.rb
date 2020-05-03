FactoryBot.define do
  factory :task do
    sequence(:title) { |n| "タイトル#{n}" }
    content { "内容" }
    status { :todo }
    deadline { 1.week.from_now }
  end
end
