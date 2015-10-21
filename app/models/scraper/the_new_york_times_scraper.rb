# Import all the libraries neccessay
require 'Date'
require 'open-uri'
require 'json'
require 'net/http'
require 'rubygems'
require 'engtagger'


class TheNewYorkTimesScraper < Scraper

  # Initialize by getting a keyword to set the usl to parse
  def initialize (keyword)
    @articles = []
    # array of arrays of keywords to use as tags
    @extracted_tags = []
    @keyword = keyword
	  @source = Source.find_by(name: 'The New York Times', keyword: keyword)

    # Find out the title of the last article of this source
	  if Article.where(source: @source).count != 0
	   	@last_title = Article.where(source: @source).last.title
    else
      @last_title = nil
	  end
	end


  # Call scrpae_with_extracted_tags since this article contains tag session.
	def scrape
    scrape_with_extracted_tags
  end



	private

		# Retriving data using the url
		def retrieve_data

			# Define the URL
      url = 'http://api.nytimes.com/svc/search/v2/articlesearch.json?q='
      url += @keyword
      url += '&sort=newest&page=1&api-key=4368bba38fc93f9f546ca5a320bafad0%3A13%3A72738011'
   
      # Define the HTTP object
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)

      # Get the response 
      response = http.get(uri)
    
      # Parse the response body
      forecast = JSON.parse(response.body)

      # Start parsing
      forecast['response']['docs'].each do |each_article|


        # If the title of thie article matches the title of the last saved article,
        # stop scraping to avoid from saving duplicates in database
        if !@last_title.nil? and @last_title.eql? each_article['headline']['main']
          break
        end

        # Try to get the author of this article
        # If any error occurs doing it, set author as nil
        begin
          author = ''
          each_article['byline']['person'].each do |person|
            author += person['firstname'] + ' '
            author += person['lastname']
            break
          end          
        rescue 
          author = nil
        end

        # If the length of the author is zero, set it as nil
        if !author.nil? and author.length == 0
          author = nil
        end


        # Just get the first image
        image = nil
        each_article['multimedia'].each do |media|
          image = media['url']
          break
        end
                

        # Make a template dictionary to put @articles
        temp = {
          :author => author,
          :title => each_article['headline']['main'],
          :summary => each_article['snippet'],
          :image => image,
          :date_time => each_article['pub_date'].to_s,
          :link => each_article['web_url']
        }

        # Get all the keywords to use as tags
        keywords = []
        each_article['keywords'].each do |keyword|
          keywords << keyword['value']
        end

        # put the keyword array into @extracted_tags to use later
        @extracted_tags << keywords
      
        # put this article into the array of articles
        @articles << temp
      end
    end
  
end
