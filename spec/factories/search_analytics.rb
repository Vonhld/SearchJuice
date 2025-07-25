FactoryBot.define do
  factory :search_analytic do
    user_ip { Faker::Internet.ip_v4_address }
    query { Faker::Quote.famous_last_words }
  end
end