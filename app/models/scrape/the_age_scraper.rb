# Import all the libraries neccessay
require 'date'
require 'rss'
require 'open-uri'

module Scrape
  class TheAgeScraper < Scraper
    # Initialize by the constructor of its parent class
    def initialize
      super('The Age')
    end

    private

    # Retriving data using the url
    def retrieve_data
      # Define the url
      url = 'http://www.theage.com.au/rssheadlines/top.xml'
      # Open the url and parse the rss feed
      open(url) do |rss|
        # Start parsing
        feed = RSS::Parser.parse(rss, false)
        # Iterate each item and scrape information
        feed.items.reverse_each do |item|
          # If the title of thie article matches the title of the last saved article,
          # stop scraping to avoid from saving duplicates in database
          break if !@last_title.nil? && @last_title.eql?(item.title)

          # If thie article is already stored then ignore
          next if Article.find_by(title: item.title)

          # Make a template dictionary to put @articles
          temp = {
            author: nil,
            title: item.title,
            summary: item.description,
            image: nil,
            link: item.link,
            date_time: DateTime.parse(item.pubDate.to_s),
            categories: nil
          }

          # Put the object into articles array
          @articles << temp
        end
      end
    end
  end
end
