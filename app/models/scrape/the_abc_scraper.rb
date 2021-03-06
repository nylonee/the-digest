# Import all the libraries neccessay
require 'date'
require 'rss'
require 'open-uri'

module Scrape
  class TheAbcScraper < Scraper
    # Initialize using the parent's constructor passing a source name
    def initialize
      super('The ABC')
    end

    private

    # Retriving data using the url
    def retrieve_data
      # Define the url
      url = 'http://www.abc.net.au/radionational/feed/3771046/rss.xml'

      # Open the url and parse the rss feed
      open(url) do |rss|
        # Start parsing
        feed = RSS::Parser.parse(rss, false)

        # Iterate each item and scrape information
        feed.items.each do |item|
          # If the title of thie article matches the title of the last saved article,
          # stop scraping to avoid from saving duplicates in database
          break if !@last_title.nil? && @last_title.eql?(item.title.to_s)

          # If thie article is already stored then ignore
          next if Article.find_by(title: item.title.to_s)

          # Get the author
          regex_author = /<dc:creator>(.*)<\/dc:creator>/
          regex_author.match(item.to_s)
          author = Regexp.last_match(1)

          author = nil if author.eql? ''

          # Get categories values
          regex_category = /<category>(.*)<\/category>/

          categories = []
          item.categories.each do |category|
            regex_category.match(category.to_s)
            categories.push(Regexp.last_match(1))
          end

          # Make a template dictionary to put @articles
          temp = {
            author: author,
            title: item.title,
            summary: item.description.to_s,
            image: nil,
            date_time: DateTime.parse(item.pubDate.to_s),
            link: item.link,
            categories: categories.join(',')
          }

          # Put the object into articles array
          @articles << temp
        end
      end
    end
  end
end
