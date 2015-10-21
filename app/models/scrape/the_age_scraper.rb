# Import all the libraries neccessay
require 'date'
require 'rss'
require 'open-uri'
require 'rubygems'
require 'engtagger'

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
        feed.items.each do |item|

          # If the title of thie article matches the title of the last saved article,
          # stop scraping to avoid from saving duplicates in database
          if !@last_title.nil? and @last_title.eql? item.title
            break
          end


          # Make a template dictionary to put @articles
          temp = {
            :author => nil,
            :title => item.title,
            :summary => item.description,
            :image => nil,
            :link => item.link,
            :date_time => DateTime.parse(item.pubDate.to_s),
            :categories => nil
          }

          # Put the object into articles array
          @articles << temp
        end
      end
    end
  end
end
