# Import all the libraries neccessay
require 'Date'
require 'rss'
require 'open-uri'
require 'rubygems'
require 'engtagger'


class TheSydneyMorningHeraldScraper < Scraper

  # Initialize by the constructor of its parent class
  def initialize
    super('The Sydney Morning Herald')
	end


	private

		# Retriving data using the url
		def retrieve_data

			# Define the url
      url = 'http://feeds.smh.com.au/rssheadlines/entertainment.xml'
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

          # Define regex to pull out img url from description
          rgx_img1 = /http:(.)+.jpg-90x60.jpg/
          rgx_img2 = /http:(.)+.png-90x60.png/

          # Pull out img url
          img = item.description.match(rgx_img1).to_s
          if(!img)
            img = item.description.match(rgx_img2).to_s
          end

          # Define regex to pull out a pure description from description
          rgx_sum =  /<\/p>[A-Z](.)+\./ 

          # Pull out a pure description
          summary = item.description.to_s.match(rgx_sum).to_s.slice!(/[A-Z](.)+\./)
          

          # Make a template dictionary to put @articles
          temp = {
            :author => nil,
            :title => item.title,
            :summary => summary,
            :image => img,
            :link => item.link,
            :date_time => item.pubDate.to_s
          }

          # Put the object into articles array
          @articles << temp
        end
      end
    end
end
