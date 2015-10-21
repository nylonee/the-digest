# The parent class for all the importers
module Scrape

  class Scraper
    # Initialized by given a source_name
    def initialize (source_name)
      @articles = []
      @source = Source.find_by(name: source_name)

      # Find out the title of the last article of this source
      if Article.where(source: @source).count != 0
        @last_title = Article.where(source: @source).last.title
      else
        @last_title = nil
      end
    end

    # Scrape the articles and tag them
    def scrape
      # array to store new article objects
      @new_articles = []

      # retrieve_data from the source
      retrieve_data

      # store each article information into database
      @articles.reverse.each do |a|
        article = Article.new(a)
        article.source = @source
        article.save
        @new_articles << article
      end

      @new_articles
    end

  end

end
