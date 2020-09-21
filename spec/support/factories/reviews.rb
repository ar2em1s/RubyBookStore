FactoryBot.define do
  factory :review do
    title { Faker::Lorem.sentence }
    body { Faker::Lorem.paragraph_by_chars }
    book { create(:book) }
    user { create(:user) }
    book_rate { rand(1..5) }
    status { Review.statuses[:approved] }
    date { Time.zone.today }
  end
end
