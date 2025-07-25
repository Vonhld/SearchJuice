150.times do
  Article.create!(
    title: "#{Faker::Science.tool} #{Faker::Science.modifier} #{Faker::Science.element}",
    summary: Faker::Educator.degree,
    author_name: Faker::Book.author,
    content: Faker::Lorem.paragraphs(number: 10).join("\n\n"),
    category: Faker::Educator.subject,
    published_at: rand(1..365).days.ago
  )
end

puts "Created #{Article.count} articles"