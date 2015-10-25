# Import necessary ruby gems
require 'rubygems'
require 'bundler/setup'
require 'indico'

module Tag
  # Tag the given article with its summary
  # Uses Indico ruby gem
  class TagBySummary
    def initialize
      # get the api key
      Indico.api_key = '18bdf53f8c24bc862f85ca021583cfe3'
    end

    def tag_by_summary(article)
      # Initialize keywords
      ind_keywords = Indico.keywords (article.summary)

      # Get the keywords
      ind_keywords.each do |keyword, _value|
        article.tag_list << keyword
      end

      article.save
    end
  end
end
