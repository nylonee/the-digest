
# Import all the libraries neccessay
require 'Date'
require 'rss'
require 'open-uri'
require 'rubygems'
require 'engtagger'


class TheAbcScraper < Scraper

 # Initialize using the parent's constructor and add @sectionIds 
  # to save a value used for tag_list
  def initialize
    super('The ABC')
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


          regex=/<dc:creator>(.*)<\/dc:creator>/  
          regex.match(item.to_s)  
          author = $1


          # Make a template dictionary to put @articles
          temp = {
            :author => author,
            :title => item.title,
            :summary => item.description.to_s,
            :image => nil,
            :date_time => item.pubDate.to_s,
            :link => item.link
          }
        
          # Put the object into articles array
          @articles << temp
        end
      end
    end



