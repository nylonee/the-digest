# Import all the libraries neccessay
require 'Date'
require 'rss'
require 'open-uri'
require 'rubygems'
require 'engtagger'


class TheSbsScraper < Scraper

  # Initialize by the constructor of its parent class
  def initialize
    super('The SBS')
	end


	private

	  # Retriving data using the url
	  def retrieve_data
		  # Define the url
      url = 'http://www.sbs.com.au/news/rss/news/science-technology.xml'
    
      # Open the url and parse the rss feed
      open(url) do |rss|
        # Start parsing
        feed = RSS::Parser.parse(rss, false)
      
        # Iterate each item and scrape information
        feed.items.each do |item|

          # If the title of thie article matches the title of the last saved article,
          # stop scraping to avoid from saving duplicates in database
          if !@last_title.nil? and @last_title.eql? item.title.to_s
            break
          end

          # Make a template dictionary to put @articles
          temp = {
            :author => nil,
            :title => item.title,
            :summary => item.description,
            :image => nil,
            :date_time => item.pubDate.to_s,
            :link => item.link
          }
        
          # Put the object into articles array
          @articles << temp
        end
      end
	  end

end
