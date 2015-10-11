# Import all the libraries neccessay
require 'rubygems'
require 'engtagger'

# The parent class for all the importers
class Importer


  # Initialized by given a source_name
  def initialize (source_name)
    @extracted_tags = []
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
      # Call tag_article function to tag this article
			if article.save
		  	tag_article article
			end

	  end
  end



  # Scrape the articles and tag them 
  # If there are tag session in the article itself, extract them as well
  def scrape_with_extracted_tags
    retrieve_data
    count = 0
    @articles.reverse.each do |a|
      article = Article.new(a)
      article.source = @source

      if article.save
        # Put sectionId as a tag
        article.tag_list << @extracted_tags.reverse[count]
        tag_article article
        count += 1
      end

    end
  end




	private
    # Create tag_list of the article and save it using engtagger library
	  def tag_article (article)
      tgr = EngTagger.new
      # Get the title of this article
      text = article.title.to_s
      tagged = tgr.add_tags(text)

      # If there is no noun in the title, use summary   
      if tgr.get_nouns(tagged).length == 0 and article.tag_list.length == 0
        text = article.summary.to_s
        tagged = tgr.add_tags(text)
      end
  
      # Put the tag list into database
      article.tag_list << tgr.get_nouns(tagged).keys
      article.save

	  end

end
