class SearchAnalytic < ApplicationRecord
  validates :user_ip, presence: true
  validates :query, presence: true


  scope :for_user, ->(ip) { where(user_ip: ip) }

  # Logic responsible for the word cloud
  def self.word_cloud(limit = 100)

    # Use of cache to calculate the word cloud every 5 minutes
    #Rails.cache.fetch("search_analytics/word_cloud", expires_in: 5.minutes) do
      # stop words in english to be ignored
      stop_words = %w[
          a an the is am in on at to from by with
          about are was were be been being have has
          and but or for nor so yet he she it they them
          their his her its myself yourself himself herself itself
          had do does did will would shall should can
          could may might must there this that these those
          one some any each every either neither all both few
          many more most such no not very just now here
          there when where why how
        ]

      # Grab all queries from the database
      all_queries_text = pluck(:query).join(' ')

      # Basic text processing
      words = all_queries_text.downcase.gsub(/[^a-z\s]/, '').split

      # Remove the stop words, based on our dictionary
      meaningful_words = words.reject { |word| stop_words.include?(word) || word.length < 3 }

      # Counts the frequency of each word.
      word_counts = meaningful_words.each_with_object(Hash.new(0)) { |word, counts| counts[word] += 1 }

      # Sort by frequency and take the 'top limit' (100)
      word_counts.sort_by { |_word, count| -count }.first(limit).map { |word, count| [word, count] }
    #end
  end
end
