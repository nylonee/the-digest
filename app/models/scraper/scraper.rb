# Import all the libraries neccessay
require 'rubygems'
require 'engtagger'

# The parent class for all the importers
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
	  retrieve_data
    @articles.reverse.each do |a|
	    article = Article.new(a)
      article.source = @source
      article.save
	  end
  end



end
