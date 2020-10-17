email = 'admin@example.com'
password = 'password'
AdminUser.first_or_create!(email: email) do |admin|
  admin.password = password
  admin.password_confirmation = password
end

(1..3).each do
  category = Category.create!(name: Faker::Book.genre)
  (1..5).each do
    author = Author.create!(first_name: Faker::Name.first_name, last_name: Faker::Name.last_name)
    book = Book.create!(title: Faker::Book.title, price: 1, category: category, description: Faker::Lorem.paragraph_by_chars, authors: [author])
    book.title_image = Pathname.new(Rails.root.join('app/assets/images/default_book.png')).open
    book.images = [
      Pathname.new(Rails.root.join('app/assets/images/default_book.png')).open,
      Pathname.new(Rails.root.join('app/assets/images/default_book.png')).open,
      Pathname.new(Rails.root.join('app/assets/images/default_book.png')).open
    ]
    book.save!
  end
end
