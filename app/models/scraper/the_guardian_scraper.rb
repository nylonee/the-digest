# Import all the libraries neccessay
require 'Date'
require 'open-uri'
require 'json'
require 'net/http'
require 'rubygems'
require 'engtagger'


class TheGuardianScraper < Scraper

  # Initialize using the parent's constructor and add @sectionIds 
  # to save a value used for tag_list
  def initialize
    super('The Guardian')
	end



	private
    # Retriving data using the rss url
		def retrieve_data
			# Define the URL
      url = 'http://content.guardianapis.com/search?q=food&api-key=uggudpb34qwz47bxb3rn7e4q&page=1&page-size=50'
      start_date = (Date.today - 7).strftime('%Y-%m-%d')
      end_date = (Date.today).strftime('%Y-%m-%d')
      url += '&from-date=' + start_date + '&to-date=' + end_date
   
      # Define the HTTP object
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)

      # Get the response 
      response = http.get(uri)
    
      # Parse the response body
      forecast = JSON.parse(response.body)

      # Start parsing
      forecast['response']['results'].each do |each_article|

        # If the title of thie article matches the title of the last saved article,
        # stop scraping to avoid from saving duplicates in database
        if !@last_title.nil? and @last_title.eql? each_article['webTitle']
          break
        end

        # Make a template dictionary to put in @articles
        temp = {
          :author => nil,
          :title => each_article['webTitle'],
          :summary => nil,
          :image => nil,
          :date_time => each_article['webPublicationDate'].to_s,
          :link => each_article['webUrl'],
          :categories => each_article['sectionId']
        }

      
        # put this article into the array of articles
        @articles << temp
      end
    end


end
