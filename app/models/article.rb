class Article < ApplicationRecord
  include PgSearch::Model

  # Validation
  validates :title, presence: true, length: { maximum: 100 }
  validates :summary, presence: true
  validates :author_name, presence: true
  
  pg_search_scope :search_by_all,
    against: [:title, :author_name, :summary],
    using: {
      tsearch: {
        prefix: true,
        dictionary: 'english'
      }
    }
end
