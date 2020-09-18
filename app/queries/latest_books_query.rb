class LatestBooksQuery
  def self.call(amount)
    Book.order(created_at: :desc).limit(amount).with_authors
  end
end
