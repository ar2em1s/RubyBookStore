class FilteredAndSortedBooks
  def self.query(category: nil, sort: nil)
    books = Book.where(nil)
    books = books.where(category: category) if category.present?
    books = books.ordered(sort) if sort.present?
    books
  end
end
