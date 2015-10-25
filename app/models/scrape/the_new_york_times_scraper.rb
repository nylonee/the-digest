# Import all the libraries neccessay
require 'date'
require 'open-uri'
require 'json'
require 'net/http'

module Scrape
  class TheNewYorkTimesScraper < Scraper
    # Initialize using parent's constructor passing source name
    def initialize
      super('The New York Times')
    end

    private

    # Takes in response.docs.multimedia from the JSON article (array), and returns
    # the URL to the largest image found
    def url_of_largest_image(multimedia_json)
      largest = multimedia_json.max_by do |image|
        image['width'] * image['height']
      end
      largest != [] ? "nytimes.com\/" + largest['url'] : nil
    end

    # Retriving data using the url
    def retrieve_data
      # Define the URL
      url = 'http://api.nytimes.com/svc/search/v2/articlesearch.json?q='
      url += 'science'
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
        if !@last_title.nil? && @last_title.eql?(each_article['headline']['main'])
          break
        end

        # If thie article is already stored then ignore
        next if Article.find_by(title: each_article['headline']['main'])

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
        author = nil if !author.nil? && author.length == 0

        # Author field is sometimes an empty array, prevent a TypeError
        # Standardize the author input
        # COMMENTED OUT BECAUSE THIS USES `each_article['byline']` WHICH IS NOT AN ACCURATE
        # REPRESENTATION OF AUTHOR (eg. 'The Associated Press')
        # author = each_article['byline'].is_a?(Array) ?
        #  nil : each_article['byline']['original'].sub('By ', '').split.map(&:capitalize).join(' ')

        # Get the largest image
        image = each_article['multimedia'] != [] ?
          url_of_largest_image(each_article['multimedia']) : nil

        # Get all the keywords to use as tags
        keywords = []
        each_article['keywords'].each do |keyword|
          keywords << keyword['value']
        end
        keywords = keywords.join(',')

        # Make a template dictionary to put @articles
        temp = {
          author: author,
          title: each_article['headline']['main'],
          summary: each_article['snippet'],
          image: image,
          date_time: DateTime.parse(each_article['pub_date'].to_s),
          link: each_article['web_url'],
          categories: keywords
        }

        # put this article into the array of articles
        @articles << temp
      end
    end
  end
end
