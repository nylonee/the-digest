require 'rubygems'
require 'bundler/setup'
require 'alchemy_api'

module Tag

  # Tag the given article with its summary
  # Uses Alchemy ruby gem
  class TagBySummary 

  	API_KEY = '7c716e88e4261f02196b83ce0abd59637e2cf8fc'

  	def self.tag_by_summary (article)

  		# get the api key
			AlchemyAPI.key = API_KEY

			# get all the entities from summary and put in the tag list
			a_entities = AlchemyAPI::EntityExtraction.new.search(text: article.summary)
			a_entities.each do |e|
				article.tag_list << e['text']
			end

			# get all the concepts from summary and put in the tag list
			a_concepts = AlchemyAPI::ConceptTagging.new.search(text: article.summary)
			a_concepts.each do |c|
				article.tag_list << c['text']
			end

			# save the article
			article.save
		end

  end

end
