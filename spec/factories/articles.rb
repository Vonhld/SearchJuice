FactoryBot.define do
  factory :article do
    title { Faker::Book.title }
    summary { "summary" }
    author_name { Faker::Name.name  }
    content { "content" }
    category { Faker::Educator.subject }
    published_at { 10.days.ago }
  end
end
